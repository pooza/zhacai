module Zhacai
  class Environment < Ginseng::Environment
    def self.name
      return File.basename(dir)
    end

    def self.dir
      return Zhacai.dir
    end
  end
end
