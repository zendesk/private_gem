require_relative 'minitest_helper'

describe PrivateGem do
  it 'has a version number' do
    PrivateGem::VERSION.wont_be_nil
  end

  describe "CLI" do
    around do |test|
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) { test.call }
      end
    end

    it "shows version" do
      privat_gem("version").must_equal "#{PrivateGem::VERSION}\n"
    end

    it "shows help" do
      privat_gem("help").must_include "private_gem new"
    end

    it "shows nothing on unknown command" do
      privat_gem("sdfsfddfs", fail: true).must_equal ""
    end

    it "shows help for subcommands" do
      privat_gem("help new").must_include "--bin"
    end

    describe "new" do
      it "generates a new project" do
        privat_gem("new foo")
        Dir.chdir("foo") do
          File.exist?(".travis.yml").must_equal true
          File.exist?(".gitignore").must_equal true
          File.exist?("bin/foo").must_equal false
          File.exist?("CHANGELOG.md").must_equal true
        end
      end

      it "generates a new project with binary" do
        privat_gem("new foo -b")
        File.exist?("foo/bin/foo").must_equal true
      end
    end

    def privat_gem(command="", options={})
      sh("#{Bundler.root}/bin/private_gem #{command}", options)
    end

    def sh(command, options={})
      result = Bundler.with_clean_env { `#{command} #{"2>&1" unless options[:keep_output]}` }
      raise "#{options[:fail] ? "SUCCESS" : "FAIL"} #{command}\n#{result}" if $?.success? == !!options[:fail]
      result
    end
  end
end
