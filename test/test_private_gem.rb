require 'minitest_helper'

describe PrivateGem do
  it 'has a version number' do
    ::PrivateGem::VERSION.wont_be_nil
  end
end
