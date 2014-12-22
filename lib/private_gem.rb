require 'private_gem/version'
require 'bundler'
require 'uri'

module PrivateGem
  def self.server
    urls_with_credentials = Bundler.settings.all.select do |n|
      url = URI.parse(n)
      url && ['http', 'https'].include?(url.scheme)
    end

    hosts_with_credentials = Bundler.settings.all.select do |n|
      n =~ /^([-_a-z\d]+\.)+[a-z]+$/
    end

    if private_gem_server = Bundler.settings['private_gem_server']
      if urls_with_credentials.include?(private_gem_server)
        return private_gem_server
      end

      private_gem_server_uri = URI.parse(private_gem_server)
      if private_gem_server_uri && hosts_with_credentials.include?(private_gem_server_uri.host)
        return private_gem_server
      end

      abort("You don't have any configured credentials for the private gem server at #{private_gem_server}")
    end

    if urls_with_credentials.empty?
      abort("You don't have any configured private gem credentials.")
    end

    if urls_with_credentials.size > 1
      msg = "You have multiple private gem servers defined:\n"
      urls_with_credentials.each do |s|
        msg << "  #{s}\n"
      end
      abort("#{msg}You need to select which private gem server to use using `bundle config private_gem_server URL_OF_GEM_SERVER`")
    end

    urls_with_credentials.first
  end

  def self.credentials
    Bundler.settings[server] || Bundler.settings[URI.parse(server).host]
  end
end
