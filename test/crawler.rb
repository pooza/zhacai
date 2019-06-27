module Zhacai
  class CrawlerTest < Test::Unit::TestCase
    def setup
      @config = Config.instance
      return unless ENV['CI'].present?
      @config['/growi/entries'] = []
      @config['/growi/uri'] = 'https://growi.b-shock.org'
    end

    def test_all
      assert(Crawler.all.present?)
      Crawler.all do |crawler|
        assert(crawler.is_a?(Crawler))
      end
    end

    def test_template_name
      Crawler.all do |crawler|
        assert(crawler.template_name.present?)
      end
    end

    def test_ignore_paths
      Crawler.all do |crawler|
        assert(crawler.ignore_paths.is_a?(Array))
      end
    end

    def test_body
      Crawler.all do |crawler|
        assert(crawler.body.present?)
      end
    end

    def test_hook_uri
      Crawler.all do |crawler|
        assert(crawler.hook_uri.is_a?(Ginseng::URI))
        assert(crawler.hook_uri.absolute?)
      end
    end

    def test_article_list_uri
      Crawler.all do |crawler|
        assert(crawler.article_list_uri.is_a?(Ginseng::URI))
        assert(crawler.article_list_uri.absolute?)
        assert(crawler.article_list_uri.query_values['access_token'].present?)
        assert(crawler.article_list_uri.query_values['path'].present?)
      end
    end

    def test_create_entry_uri
      return unless crawler = Crawler.all.to_a.first
      assert(crawler.create_entry_uri('/news').absolute?)
    end

    def test_entries
      Crawler.all do |crawler|
        assert(crawler.entries.is_a?(Array))
        assert(crawler.entries.present?)
      end
    end
  end
end
