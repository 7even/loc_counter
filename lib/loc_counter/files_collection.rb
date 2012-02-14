module LOCCounter
  # A class representing a collection of arbitrary files.
  class FilesCollection
    # All parsed files in the collection.
    # @return [Array]
    attr_reader :files
    
    # Regexp for Ruby source file paths
    RUBY_FILES = /((Cap|Gem|Rake)file|\.(gemspec|rake|rb)|bin\/\w+)$/
    
    # @param [Array] file_paths Paths to files being processed
    def initialize(file_paths)
      @files = []
      file_paths.each do |path|
        @files << SourceFile.new(path) if path =~ RUBY_FILES
      end
    end
    
    # Summarized line counts for all files in the collection.
    # @example
    #   collection = LOCCounter::FilesCollection.new(paths)
    #   collection.counts
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
