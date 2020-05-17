require 'time'
require 'uri'

module Zhacai
  class Crawler
    def initialize(params)
      @config = Config.instance
      @params = params.key_flatten
      @http = HTTP.new
    end

    def exec
      puts body
    end

    def body
      template = Template.new(template)
      template[:crawler] = self
      return template.to_s
    end

    def template
      return @params['/template'] || 'message'
    end

    def ignore_paths
      return @params['/ignore_paths'] || []
    end

    def entries
      entries = {}
      @http.get(article_list_uri).parsed_response['pages'].each_with_index do |entry, i|
        next if ignore_paths.include?(entry['path'])
        break unless i < @config['/message/entries/limit']
        time = Time.parse(entry['updatedAt']).getlocal(Environment.tz)
        uri = create_entry_uri(entry['path'])
        entries[time.to_s] = {
          date: time,
          title: URI.decode_www_form_component(uri.path.split('/').last),
          uri: uri,
        }
      end
      return entries.sort.reverse
    end

    def article_list_uri
      uri = Ginseng::URI.parse(@config['/growi/url'])
      uri.path = '/_api/pages.list'
      uri.query_values = {
        'access_token' => @config['/growi/token'],
        'path' => @params['/path'],
      }
      return uri
    end

    def create_entry_uri(path)
      uri = Ginseng::URI.parse(@config['/growi/url'])
      uri.path = path
      return uri
    end

    def self.crawl_all(params = {})
      params[:post] = true unless params.present?
      all.map {|entry| entry.crawl(params)}
    end

    def self.all
      return enum_for(__method__) unless block_given?
      Config.instance['/growi/entries'].each do |entry|
        yield Crawler.new(entry)
      end
    end
  end
end
