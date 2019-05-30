require 'addressable/uri'

module Zhacai
  class Crawler
    def initialize(params)
      @config = Config.instance
      @logger = Logger.new
    end

    def crawl
      Slack.new(hook_uri).say(body, :text)
      @logger.info(params)
    rescue => e
      e = Ginseng::Error.create(e)
      e.package = Package.full_name
      Slack.broadcast(e.to_h)
      @logger.error(e.to_h)
    end

    def body
      template = Template.new('toot')
      template[:crawler] = self
      return template.to_s
    end

    def hook_uri
      @hook_uri ||= Addressable::URI.parse(@params['/hook'])
      return @hook_uri
    end

    def tags
      return @params['/tags'] || []
    end

    def self.crawl_all
      all(&:crawl)
    end

    def self.all
      return enum_for(__method__) unless block_given?
      Config.instance['/growi/entries'].each do |entry|
        yield Crawler.new(entry)
      end
    end
  end
end
