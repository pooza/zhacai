namespace :zhacai do
  desc 'crawl'
  task :crawl do
    sh File.join(Zhacai::Environment.dir, 'bin/crawl.rb')
  end
end

[:crawl].each do |action|
  desc "alias of zhacai:#{action}"
  task action => "zhacai:#{action}"
end
