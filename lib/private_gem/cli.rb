require 'bundler/cli'

module PrivateGem
  class CLI < Thor
    include Thor::Actions

    default_task :help

    desc 'version', 'show version'
    def version
      puts PrivateGem::VERSION
    end

    desc 'new GEM [OPTIONS]', 'Creates a skeleton for a private ruby gem'
    method_option :bin, :type => :boolean, :default => false, :aliases => '-b', :banner => 'Generate a binary for your gem.'
    def new(gem_name)
      name = gem_name.chomp('/') # remove trailing slash if present
      underscored_name = name.tr('-', '_')
      namespaced_path = name.tr('-', '/')
      target = File.join(Dir.pwd, name)
      constant_name = name.split('_').map{|p| p[0..0].upcase + p[1..-1] }.join
      constant_name = constant_name.split('-').map{|q| q[0..0].upcase + q[1..-1] }.join('::') if constant_name =~ /-/
      constant_array = constant_name.split('::')
      git_user_name = `git config user.name`.chomp
      git_user_email = `git config user.email`.chomp
      opts = {
        :name             => name,
        :underscored_name => underscored_name,
        :namespaced_path  => namespaced_path,
        :constant_name    => constant_name,
        :constant_array   => constant_array,
        :author           => git_user_name.empty? ? 'TODO: Write your name' : git_user_name,
        :email            => git_user_email.empty? ? 'TODO: Write your email address' : git_user_email
      }

      template 'newgem/Gemfile.tt', "#{target}/Gemfile", opts
      template "newgem/Rakefile.tt", "#{target}/Rakefile", opts
      template "newgem/README.md.tt", "#{target}/README.md", opts
      template "newgem/CHANGELOG.md.tt", "#{target}/CHANGELOG.md", opts
      template "newgem/gitignore.tt", "#{target}/.gitignore", opts
      template "newgem/newgem.gemspec.tt", "#{target}/#{name}.gemspec", opts
      template "newgem/lib/newgem.rb.tt", "#{target}/lib/#{namespaced_path}.rb", opts
      template "newgem/lib/newgem/version.rb.tt", "#{target}/lib/#{namespaced_path}/version.rb", opts
      template "newgem/test/minitest_helper.rb.tt", "#{target}/test/minitest_helper.rb", opts
      template "newgem/test/test_newgem.rb.tt", "#{target}/test/test_#{namespaced_path}.rb", opts
      template "newgem/travis.yml.tt", "#{target}/.travis.yml", opts
      if options[:bin]
        template "newgem/bin/newgem.tt", "#{target}/bin/#{name}", opts
      end

      Dir.chdir(target) { `git init; git add .` }
    end

    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
    end
  end
end
