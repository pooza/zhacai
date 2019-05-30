dir = File.expand_path(__dir__)
$LOAD_PATH.unshift(File.join(dir, 'lib'))
ENV['BUNDLE_GEMFILE'] ||= File.join(dir, 'Gemfile')

require 'bundler/setup'
require 'zhacai'

desc 'test all'
task test: ['zhacai:test']

[:crawl, :clean, :touch].each do |action|
  desc "alias of zhacai:#{action}"
  task action => "zhacai:#{action}"
end

Dir.glob(File.join(Zhacai::Environment.dir, 'lib/task/*.rb')).each do |f|
  require f
end
