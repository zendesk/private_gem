require 'private_gem/version'
require 'bundler'

module PrivateGem
  def self.server
    servers_with_credentials = Bundler.settings.all.select do |n|
      url = URI.parse(n)
      url && ['http', 'https'].include?(url.scheme)
    end

    if private_gem_server = Bundler.settings['private_gem_server']
      if servers_with_credentials.include?(private_gem_server)
        return private_gem_server
      else
        abort("You don't have any configured credentials for the private gem server at #{private_gem_server}")
      end
    end

    if servers_with_credentials.empty?
      abort("You don't have any configured private gem credentials.")
    end

    if servers_with_credentials.size > 1
      msg = "You have multiple private gem servers defined:\n"
      servers_with_credentials.each do |s|
        msg << "  #{s}\n"
      end
      abort("#{msg}You need to select which private gem server to use using `bundle config private_gem_server URL_OF_GEM_SERVER`")
    end

    servers_with_credentials.first
  end

  def self.credentials
    Bundler.settings[server]
  end
end
