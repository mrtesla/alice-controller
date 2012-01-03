class C
  require 'openssl'
  require 'base64'

  class Identity
    attr_reader :key_id

    def initialize(key_id)
      @key_id = key_id
    end
  end

  class LocalIdentity < Identity
    attr_reader :private_key_data, :private_key

    def initialize(key_id, private_key_data)
      super(key_id)
      @private_key_data = private_key_data
    end

    def private_key
      @private_key ||= begin
        OpenSSL::PKey::RSA.new(self.private_key_data)
      end
    end
  end

  class RemoteIdentity < Identity
    attr_reader :public_key_data, :public_key

    def initialize(key_id, public_key_data)
      super(key_id)
      @public_key_data = public_key_data
    end

    def public_key
      @public_key ||= begin
        OpenSSL::PKey::RSA.new(self.public_key_data)
      end
    end
  end

  def initialize(app)
    @app = app
  end

  def call(env)
    dup._call(env)
  end

  def _call(env)
    @env = env

    if crypto?
      lookup_local_identity  or return [422, {}, []]
      lookup_remote_identity or return [422, {}, []]
      verify_request         or return [422, {}, []]
      process_request_body   or return [422, {}, []]

      @env['rack.crypto.local']  = @local_identity
      @env['rack.crypto.remote'] = @remote_identity

      @status, @headers, @body = *@app.call(env)
      return [@status, @headers, @body] if     @status == -1
      return [@status, @headers, @body] unless @status >= 200 and @status < 300

      process_response_body
      return [@status, @headers, @body]
    else
      @app.call(env)
    end
  end

  def crypto?
    @env['HTTP_X_CRYPTO_KEY_ID'] and
      @env['HTTP_X_CRYPTO_NONCE'] and
      @env['HTTP_X_CRYPTO_SIGNATURE']
  end

  def lookup_local_identity
    identity = @options[:local_identity].call()
    unless LocalIdentity === identity
      return false
    end

    @local_identity = identity
  end

  def lookup_remote_identity
    key_id = @env['HTTP_X_CRYPTO_KEY_ID']

    identity = @options[:remote_identity].call(key_id)
    unless RemoteIdentity === identity
      return false
    end

    @remote_identity = identity
  end

  def verify_request
    key_id     = @remote_identity.key_id
    public_key = @remote_identity.public_key
    signature  = @env['HTTP_X_CRYPTO_SIGNATURE'] || ''
    nonce      = @env['HTTP_X_CRYPTO_NONCE']

    if @env['CONTENT_TYPE'] === 'application/x-crypto'
      @env['rack.input'].rewind
      body = @body = @env['rack.input'].read
    else
      body = ''
    end

    digest = OpenSSL::Digest::SHA256.new
    public_key.verify(digest, signature,
                      [key_id, nonce, body].join(''))
  end

  def process_request_body
    return true unless @body

    private_key = @local_identity.private_key

    @body = private_key.private_decrypt(@body)
    unless @body
      return false
    end

    @body.split('\n', 2).tap do |(content_type, body)|
      env['CONTENT_TYPE']   = content_type
      env['CONTENT_LENGTH'] = body.bytesize
      env['rack.input'] = StringIO.new(body)
      @body = nil
    end

    true
  end

  def process_response_body
    public_key  = @remote_identity.public_key
    private_key = @local_identity.private_key
    key_id      = @local_identity.key_id

    buffer = "#{@headers['Content-Type']}\n"
    @body.each { |chunk| buffer.concat chunk }
    @body = public_key.public_encrypt(buffer)

    digest    = OpenSSL::Digest::SHA256.new
    nonce     = Base64.encode64(OpenSSL::Random.random_bytes(256))
    signature = private_key.sign(digest, [key_id, nonce, @body].join(''))

    @headers['X-Crypto-Key-Id']    = key_id
    @headers['X-Crypto-Signature'] = signature
    @headers['X-Crypto-Nonce']     = nonce
    @headers['Content-Type']       = "application/x-crypto"
    @headers['Content-Length']     = body.bytesize
    @headers.delete('Transfer-Encoding')

    @body = [@body]
  end

end
