module Documents
  class Folder
    def self.for(path)
      new(path).ensure_existance
    end

    def initialize(path)
      @path = path
    end

    def ensure_existance
      make_folder if folder_missing?
    end

    private

    attr_reader :path

    def make_folder
      FileUtils.mkdir_p(path)
    end

    def folder_missing?
      File.directory?(path) == false
    end
  end
end
