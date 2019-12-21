namespace :zhacai do
  desc 'crawl'
  task :crawl do
    sh File.join(Zhacai::Environment.dir, 'bin/crawl.rb')
  end
end
