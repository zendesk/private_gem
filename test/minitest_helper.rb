require 'bundler/setup'

# ensure everyone has the same env
Bundler::ORIGINAL_ENV.delete_if { |k| k.start_with?("BUNDLE_HTTP") }

# ensure no 1-off ~/.bundle/config breaks tests
require 'tmpdir'
original = File.expand_path("~/.bundle/config")
if File.exist?(original)
  dir = Dir.mktmpdir
  Bundler::ORIGINAL_ENV["HOME"] = dir
  Dir.mkdir "#{dir}/.bundle"
  File.write("#{dir}/.bundle/config", File.read(original).gsub(/.*BUNDLE_HTTP.*/, ""))
end

require 'private_gem'

require 'maxitest/global_must'
require 'maxitest/autorun'
require 'maxitest/timeout'
