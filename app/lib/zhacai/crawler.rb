require 'time'
require 'uri'

module Zhacai
  class Crawler
    def exec
      puts body
    end

    def body
      template = Template.new(self.template)
      template[:crawler] = self
      return template.to_s
    end

    def key
      return @params['/key']
    end

    def template
      return @params['/template'] || 'message'
    end

    def ignore_paths
      return @params['/ignore_paths'] || []
    end

    def entries
      entries = []
      @http.get(uri).parsed_response['pages'].each_with_index do |entry, i|
        next if ignore_paths.include?(entry['path'])
        break unless i < @config['/message/entries/limit']
        entries.push(
          date: Time.parse(entry['updatedAt']).getlocal,
          title: URI.decode_www_form_component(entry['path'].split('/').last),
          uri: @http.create_uri(entry['path']),
        )
      end
      return entries.sort_by {|v| v[:date]}.reverse
    end

    def uri
      unless @uri
        @uri = @http.create_uri('/_api/pages.list')
        @uri.query_values = {
          'access_token' => @config['/growi/token'],
          'path' => @params['/path'],
        }
      end
      return @uri
    end

    def self.create(key)
      all do |crawler|
        return crawler if key == crawler.key
      end
      return nil
    end

    def self.all
      return enum_for(__method__) unless block_given?
      Config.instance['/entries'].each do |entry|
        yield Crawler.new(entry)
      end
    end

    private

    def initialize(params)
      @config = Config.instance
      @params = params.key_flatten
      @http = HTTP.new
      @http.base_uri = @config['/growi/url']
    end
  end
end
