dir = File.expand_path(__dir__)
$LOAD_PATH.unshift(File.join(dir, 'app/lib'))
ENV['BUNDLE_GEMFILE'] ||= File.join(dir, 'Gemfile')

require 'bundler/setup'
require 'zhacai'

[:crawl].each do |action|
  desc "alias of zhacai:#{action}"
  task action => "zhacai:#{action}"
end

Dir.glob(File.join(Zhacai::Environment.dir, 'app/task/*.rb')).each do |f|
  require f
end
