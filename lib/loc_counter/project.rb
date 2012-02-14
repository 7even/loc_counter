require 'active_support/ordered_hash'
module LOCCounter
  # A class representing a project.
  class Project < FilesCollection
    # Dir.glob patterns for project source code files paths
    SOURCE_FILES = [
      '*.{rb,gemspec}',
      '{Cap,Gem,Rake}file',
      'bin/*',
      '{app,config,lib}/**/*.{gemspec,rake,rb}'
    ]
    
    # @param [String] dir_name Path to the project directory
    def initialize(dir_name)
      raise ArgumentError, "Directory '#{dir_name}' not found" unless File.exists?(dir_name)
      
      @files = []
      SOURCE_FILES.each do |pattern|
        full_pattern = File.join(dir_name, pattern)
        
        @files += Dir.glob(full_pattern).map do |filename|
          SourceFile.new(filename)
        end
      end
    end
  end
end
