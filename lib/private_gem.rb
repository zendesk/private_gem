require 'private_gem/version'
require 'bundler'

module PrivateGem
  def self.server
    servers_with_credentials = Bundler.settings.all.select do |n|
      url = URI.parse(n)
      url && ['http', 'https'].include?(url.scheme)
    end

    if servers_with_credentials.empty?
      abort("You don't have any configured private gem credentials.")
    elsif servers_with_credentials.size > 1
      private_gem_server = Bundler.settings['private_gem_server']

      if private_gem_server
        if servers_with_credentials.include?(private_gem_server)
          return private_gem_server
        else
          abort("You don't have any configured credentials for the private gem server at #{private_gem_server}")
        end
      else
        puts "You have multiple private gem servers defined:"
        servers_with_credentials.each do |s|
          puts "  #{s}"
        end
        abort("You need to select which private gem server to use using `bundle config private_gem_server URL_OF_GEM_SERVER`")
      end
    else
      servers_with_credentials.first
    end
  end

  def self.server_with_credentials
    url = URI.parse(server)
    auth = Bundler.settings[server]
    url.user, url.password = auth.split(':', 2)
    url.to_s
  end
end
