namespace :zhacai do
  desc 'crawl'
  task :crawl do
    sh File.join(Zhacai::Environment.dir, 'bin/crawl.rb')
  end

  desc 'update timestamps'
  task :touch do
    sh "#{File.join(Zhacai::Environment.dir, 'bin/crawl.rb')} --silence"
  end

  desc 'clear timestamps'
  task :clean do
    Dir.glob(File.join(Zhacai::Environment.dir, 'tmp/timestamps/*')) do |f|
      puts "delete #{f}"
      File.unlink(f)
    end
  end
end
