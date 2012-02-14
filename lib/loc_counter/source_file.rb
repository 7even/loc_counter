module LOCCounter
  # A class representing a source code file.
  class SourceFile
    # All lines in a file.
    # @return [Array]
    attr_reader :lines
    
    # A regexp for empty lines
    EMPTY_PATTERN   = /^\s*$/
    # A regexp for lines containing just comments
    COMMENT_PATTERN = /^\s*\#.*$/
    
    # @param [String] filename Full path to the file being processed
    def initialize(filename)
      raise ArgumentError, "File '#{filename}' not found" unless File.exists?(filename)
      
      @lines = File.readlines(filename)
    end
    
    # Line counts broken by the line type.
    # 
    # Returns a hash with 4 elements:
    # - :total is total line count
    # - :empty is a number of empty lines
    # - :comments is a number of lines containing only a comment
    # - :code is a number of lines containing any code
    # @return [Hash]
    def counts
      @counts ||= begin
        counts = {
          :total    => @lines.count,
          :empty    => 0,
          :comments => 0,
          :code     => 0
        }
        
        @lines.each do |line|
          case line
          when EMPTY_PATTERN
            counts[:empty] += 1
          when COMMENT_PATTERN
            counts[:comments] += 1
          else
            counts[:code] += 1
          end
        end
        
        counts
      end
    end
  end
end
