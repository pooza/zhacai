desc 'test all'
task :test do
  ENV['TEST'] = Zhacai::Package.name
  require 'test/unit'
  Dir.glob(File.join(Zhacai::Environment.dir, 'test/*.rb')).each do |t|
    require t
  end
end
