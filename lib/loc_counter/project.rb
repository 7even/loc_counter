module LOCCounter
  # A class representing a project.
  class Project
    # All parsed files in the project
    # @return [Array]
    attr_reader :files
    
    # A Dir.glob pattern for project source code files paths
    SOURCE_FILES = '{app,config,lib}/**/*.rb'
    
    # @param [String] dir_name Path to the project directory
    def initialize(dir_name)
      raise ArgumentError, "Directory '#{dir_name}' not found" unless File.exists?(dir_name)
      
      pattern = File.join(dir_name, SOURCE_FILES)
      @files = Dir[pattern].map { |filename| SourceFile.new(filename) }
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
    # @return [Hash]
    # @see LOCCounter::SourceFile#counts
    def counts
      total_counts = {
        :total    => 0,
        :empty    => 0,
        :comments => 0,
        :code     => 0
      }
      
      @files.each do |file|
        total_counts.keys.each do |type|
          total_counts[type] += file.counts[type]
        end
      end
      
      total_counts.merge(:files => @files.count)
    end
  end
end
