require 'private_gem'
require 'bundler/gem_helper'

module PrivateGem
  module GemHelperPatches
    def install
      super

      Rake::Task[:release].clear_comments
      Rake::Task[:release].comment = "Create tag v#{version} and build and push #{name}-#{version}.gem to your private gem server"

      task :verify_gemspec do
        verify_allowed_push_host
      end

      Rake::Task[:build].enhance([:verify_gemspec])
    end

    protected

    def rubygem_push(path)
      if PrivateGem.server && PrivateGem.credentials
        Bundler.ui.confirm sh([
          "curl",
          "--silent", "--fail",
          "--data-binary", "@#{path}",
          "--user", PrivateGem.credentials,
          "--header", "Content-Type: application/octet-stream",
          "#{PrivateGem.server}api/v1/gems"
        ])

        Bundler.ui.confirm "Pushed #{name} #{version} to #{PrivateGem.server}."
      else
        raise "Your private gem server credentials aren't set."
      end
    end

    def verify_allowed_push_host
      allowed_push_host = gemspec.metadata['allowed_push_host']

      if allowed_push_host != PrivateGem.server
        abort_message = %Q~
          Please add the following to #{File.basename(spec_path)} (to prevent accidental pushes to rubygems.org):
          gemspec.metadata['allowed_push_host'] = '#{PrivateGem.server}'
        ~.gsub(/^ +/m, '')
        abort(abort_message + "\n")
      end
    end
  end
end

Bundler::GemHelper.send(:prepend, PrivateGem::GemHelperPatches)

Bundler::GemHelper.install_tasks
