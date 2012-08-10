class JSONColumn
  def initialize(default={})
    @default = default
  end

  # this might be the database default and we should plan for empty strings or nils
  def load(s)
    s.present? ? JSON.load(s) : @default
  end

  # this should only be nil or an object that serializes to JSON (like a hash or array)
  def dump(o)
    o = load(o) if String === o
    JSON.dump(o || @default)
  end
end
