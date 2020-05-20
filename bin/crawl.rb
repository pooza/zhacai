#!/usr/bin/env ruby

path = File.expand_path(__FILE__)
path = File.expand_path(File.readlink(path)) while File.symlink?(path)
dir = File.expand_path('../..', path)
$LOAD_PATH.unshift(File.join(dir, 'app/lib'))
ENV['BUNDLE_GEMFILE'] = File.join(dir, 'Gemfile')

require 'bundler/setup'
require 'zhacai'
require 'optparse'

begin
  options = ARGV.getopts('', 'entry:')
  raise 'crawler entry undefined.' unless name = options['entry']
  unless crawler = Zhacai::Crawler.create(name)
    raise "crawler '#{name}' undefined."
  end
  crawler.exec
rescue => e
  warn e.message
  exit 1
end
