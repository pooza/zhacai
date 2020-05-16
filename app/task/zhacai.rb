namespace :zhacai do
  desc 'alias of zhacai:post'
  task crawl: [:post]

  desc 'post'
  task :post do
    Zhacai::Crawler.crawl_all
  end

  desc 'print'
  task :print do
    Zhacai::Crawler.crawl_all(print: true)
  end
end

[:crawl, :post, :print].each do |action|
  desc "alias of zhacai:#{action}"
  task action => "zhacai:#{action}"
end
