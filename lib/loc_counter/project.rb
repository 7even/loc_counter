require 'active_support/ordered_hash'
module LOCCounter
  # A class representing a project.
  class Project
    # All parsed files in the project
    # @return [Array]
    attr_reader :files
    
    # Dir.glob patterns for project source code files paths
    SOURCE_FILES = [
      '*.{rb,gemspec}',
      '{Cap,Gem,Rake}file',
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
    
    # Summarized line counts for all files in a project.
    # @example
    #   project = LOCCounter::Project.new(path)
    #   project.counts
    #   # => {
    #   #    :total => 1606,
    #   #    :empty => 292,
    #   # :comments => 360,
    #   #     :code => 954,
    #   #    :files => 43
    #   # }
    # @return [ActiveSupport::OrderedHash]
    # @see LOCCounter::SourceFile#counts
    def counts
      total_counts = ActiveSupport::OrderedHash.new
      [:total, :empty, :comments, :code].each { |type| total_counts[type] = 0 }
      
      @files.each do |file|
        total_counts.keys.each do |type|
          total_counts[type] += file.counts[type]
        end
      end
      
      total_counts.merge(:files => @files.count)
    end
  end
end
