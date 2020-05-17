module Zhacai
  class CrawlerTest < Test::Unit::TestCase
    def setup
      @config = Config.instance
      return unless Environment.ci?
      @config['/growi/entries'] = []
      @config['/growi/uri'] = 'https://growi.b-shock.org'
    end

    def test_all
      assert(Crawler.all.present?)
      Crawler.all do |crawler|
        assert(crawler.is_a?(Crawler))
      end
    end

    def test_template
      Crawler.all do |crawler|
        assert(crawler.template.present?)
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

    def test_uri
      Crawler.all do |crawler|
        assert(crawler.uri.is_a?(Ginseng::URI))
        assert(crawler.uri.absolute?)
      end
    end

    def test_entries
      Crawler.all do |crawler|
        assert(crawler.entries.is_a?(Array))
        assert(crawler.entries.present?)
      end
    end

    def test_exec
      Crawler.all(&:exec)
    end
  end
end
