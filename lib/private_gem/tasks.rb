require 'private_gem'
require 'bundler/gem_helper'

module PrivateGem
  module GemHelperPatches
    def install
      super

      Rake::Task[:release].clear_comments
      Rake::Task[:release].comment = "Create tag v#{version} and build and push #{name}-#{version}.gem to #{PrivateGem.server}"

      task :verify_gemspec do
        verify_allowed_push_host
      end

      Rake::Task[:build].enhance([:verify_gemspec])
    end

    protected

    def rubygem_push(path)
      if PrivateGem.server && PrivateGem.credentials
        Bundler.ui.confirm sh("curl --data-binary '@#{path}' --user '#{PrivateGem.credentials}' --header 'Content-Type: application/octet-stream' --silent #{PrivateGem.server}api/v1/gems")

        Bundler.ui.confirm "Pushed #{name} #{version} to #{PrivateGem.server}."
      else
        raise "Your private gem server credentials aren't set."
      end
    end

    def verify_allowed_push_host
      allowed_push_host = gemspec.metadata['allowed_push_host']

      if allowed_push_host != PrivateGem.server
        abort("You must set allowed_push_host to #{PrivateGem.server} in #{File.basename(spec_path)} to prevent accidental pushes to rubygems.org")
      end
    end
  end
end

Bundler::GemHelper.prepend(PrivateGem::GemHelperPatches)

Bundler::GemHelper.install_tasks
