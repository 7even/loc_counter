module FilesCollectionHelpers
  # setting filenames, files and LOCCounter::SourceFile.new
  def stub_files
    @filename1  = stub("First file name")
    @filename2  = stub("Second file name")
    @filenames  = [@filename1, @filename2]
    
    @file1 = stub("LOCCounter::SourceFile instance for filename1")
    @file2 = stub("LOCCounter::SourceFile instance for filename2")
    @files = [@file1, @file2]
    
    LOCCounter::SourceFile.stub(:new) do |filename|
      case filename
      when @filename1 then @file1
      when @filename2 then @file2
      end
    end
  end
end
