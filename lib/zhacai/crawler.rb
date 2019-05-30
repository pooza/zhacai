require 'addressable/uri'
require 'time'
require 'uri'

module Zhacai
  class Crawler
    attr_reader :params

    def initialize(params)
      @config = Config.instance
      @params = Config.flatten('', params)
      @logger = Logger.new
      @http = HTTP.new
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
      template = Template.new('message')
      template[:crawler] = self
      return template.to_s
    end

    def entries
      entries = {}
      @http.get(article_list_uri).parsed_response['pages'].each do |entry|
        time = Time.parse(entry['updatedAt']).getlocal(tz)
        uri = create_entry_uri(entry['path'])
        entries[time.to_s] = {
          date: time,
          title: URI.decode_www_form_component(uri.path.split('/').last),
          uri: uri,
        }
      end
      return entries.sort.reverse
    rescue => e
      @logger.error(e)
    end

    def article_list_uri
      uri = Addressable::URI.parse(@config['/growi/url'])
      uri.path = '/_api/pages.list'
      uri.query_values = {
        'access_token' => @config['/growi/token'],
        'path' => @params['/path'],
      }
      return uri
    end

    def hook_uri
      return Addressable::URI.parse(@params['/hook'])
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

    private

    def create_entry_uri(path)
      uri = Addressable::URI.parse(@config['/growi/url'])
      uri.path = path
      return uri
    end

    def tz
      return Time.now.strftime('%:z')
    end
  end
end
