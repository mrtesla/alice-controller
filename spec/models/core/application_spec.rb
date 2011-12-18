require 'spec_helper'

describe Core::Application do

  it { should have_many(:http_path_rules) }
  it { should have_many(:http_backends)   }

end
