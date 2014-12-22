require_relative 'minitest_helper'

describe 'PrivateGem.server' do
  let(:bundler_settings) { {} }
  let(:private_gem_server_host) { 'gems.company.com' }
  let(:private_gem_server) { "https://#{private_gem_server_host}/" }

  class AbortException < RuntimeError
  end

  around do |test|
    PrivateGem.stub(:abort, -> (msg) { raise AbortException.new(msg) }) do
      test.call
    end
  end

  around do |test|
    def bundler_settings.all
      keys
    end

    Bundler.stub(:settings, bundler_settings) do
      test.call
    end
  end

  describe 'PrivateGem.server' do
    describe 'when private_gem_server is present' do
      describe 'when only private_gem_server is present' do
        let(:bundler_settings) do
          {
            'private_gem_server' => private_gem_server
          }
        end

        it 'aborts complaining about missing credentials' do
          -> { PrivateGem.server }.must_raise(AbortException).message.must_match %r{You don't have any configured credentials for the private gem server at https://gems.company.com/}
        end
      end

      describe 'when no credentials for private_gem_server are present' do
        let(:bundler_settings) do
          {
            'private_gem_server' => private_gem_server,
            'https://gems.other-company.com/' => 'user:pass'
          }
        end

        it 'aborts complaining about missing credentials' do
          -> { PrivateGem.server }.must_raise(AbortException).message.must_match %r{You don't have any configured credentials for the private gem server at https://gems.company.com/}
        end
      end

      describe 'when credentials for private_gem_server are present' do
        let(:bundler_settings) do
          {
            'private_gem_server' => private_gem_server,
            'https://gems.other-company.com/' => 'user:pass',
            private_gem_server => 'user:pass'
          }
        end

        it 'returns private_gem_server' do
          PrivateGem.server.must_equal 'https://gems.company.com/'
        end
      end

      describe 'when credentials for private_gem_server host are present' do
        let(:bundler_settings) do
          {
            'private_gem_server' => private_gem_server,
            'other-company.com' => 'user:pass',
            private_gem_server_host => 'user:pass'
          }
        end

        it 'returns private_gem_server' do
          PrivateGem.server.must_equal 'https://gems.company.com/'
        end
      end
    end

    describe 'when private_gem_server is not present' do
      describe 'and no credentials are present' do
        it 'aborts complaining about missing credentials' do
          -> { PrivateGem.server }.must_raise(AbortException).message.must_match %r{You don't have any configured private gem credentials}
        end
      end

      describe 'and credentials for one server are present' do
        let(:bundler_settings) do
          {
            'https://gems.company.com/' => 'user:pass'
          }
        end

        it 'returns that one server' do
          PrivateGem.server.must_equal 'https://gems.company.com/'
        end
      end

      describe 'and credentials for multiple servers are present' do
        let(:bundler_settings) do
          {
            'https://gems.company.com/' => 'user:pass',
            'https://gems.other-company.com/' => 'user:pass'
          }
        end

        it 'aborts asking you to set private_gem_server' do
          -> { PrivateGem.server }.must_raise(AbortException).message.must_match %r{You need to select which private gem server to use using `bundle config private_gem_server URL_OF_GEM_SERVER`}
        end
      end
    end
  end

  describe 'PrivateGem.credentials' do
    describe 'when credentials for private_gem_server are present' do
      let(:bundler_settings) do
        {
          'private_gem_server' => private_gem_server,
          'https://gems.other-company.com/' => 'otheruser:otherpass',
          private_gem_server => 'user:pass'
        }
      end

      it 'returns the credentials of the private_gem_server' do
        PrivateGem.credentials.must_equal 'user:pass'
      end
    end

    describe 'when credentials for private_gem_server host are present' do
      let(:bundler_settings) do
        {
          'private_gem_server' => private_gem_server,
          'gems.other-company.com' => 'otheruser:otherpass',
          private_gem_server_host => 'user:pass'
        }
      end

      it 'returns the credentials of the private_gem_server' do
        PrivateGem.credentials.must_equal 'user:pass'
      end
    end
  end
end
