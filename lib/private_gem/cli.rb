require 'bundler/cli'

module PrivateGem
  class CLI < Thor
    include Thor::Actions

    default_task :help

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
      gemspec_dest = File.join(target, "#{name}.gemspec")
      template(File.join('newgem/Gemfile.tt'),                 File.join(target, 'Gemfile'),                             opts)
      template(File.join('newgem/Rakefile.tt'),                File.join(target, 'Rakefile'),                            opts)
      template(File.join('newgem/README.md.tt'),               File.join(target, 'README.md'),                           opts)
      template(File.join('newgem/gitignore.tt'),               File.join(target, '.gitignore'),                          opts)
      template(File.join('newgem/newgem.gemspec.tt'),          gemspec_dest,                                             opts)
      template(File.join('newgem/lib/newgem.rb.tt'),           File.join(target, "lib/#{namespaced_path}.rb"),           opts)
      template(File.join('newgem/lib/newgem/version.rb.tt'),   File.join(target, "lib/#{namespaced_path}/version.rb"),   opts)
      if options[:bin]
        template(File.join('newgem/bin/newgem.tt'),            File.join(target, 'bin', name),                           opts)
      end
      template(File.join('newgem/test/minitest_helper.rb.tt'), File.join(target, 'test/minitest_helper.rb'),             opts)
      template(File.join('newgem/test/test_newgem.rb.tt'),     File.join(target, "test/test_#{namespaced_path}.rb"),     opts)
      template(File.join('newgem/.travis.yml.tt'),             File.join(target, '.travis.yml'),                         opts)

      Dir.chdir(target) { `git init`; `git add .` }
    end

    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
    end
  end
end
