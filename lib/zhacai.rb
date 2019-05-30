require 'active_support'
require 'active_support/core_ext'
require 'active_support/dependencies/autoload'
require 'ginseng'

module Zhacai
  extend ActiveSupport::Autoload

  autoload :Config
  autoload :Environment
  autoload :HTTP
  autoload :Logger
  autoload :Package
  autoload :Slack
  autoload :Template
end
