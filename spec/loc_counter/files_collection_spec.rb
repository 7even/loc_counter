require 'spec_helper'

describe LOCCounter::FilesCollection do
  before(:each) do
    stub_files
    File.stub(:exists?).and_return(true)
  end
  
  describe "#initialize" do
    before(:each) do
      @filename1.stub(:=~).and_return(true)
      @filename2.stub(:=~).and_return(false)
    end
    
    it "puts the filtered files list to @files" do
      collection = LOCCounter::FilesCollection.new(@filenames)
      collection.files.should == [@file1]
    end
  end
  
  describe "#counts" do
    before(:each) do
      @file1_counts = {
        :total    => 5,
        :empty    => 0,
        :comments => 1,
        :code     => 4
      }
      @file1.stub(:counts => @file1_counts)
      
      @file2_counts = {
        :total    => 8,
        :empty    => 1,
        :comments => 2,
        :code     => 5
      }
      @file2.stub(:counts => @file2_counts)
    end
    
    it "sums line counts from all files and returns them in a hash" do
      collection = LOCCounter::FilesCollection.new(@filenames)
      collection.instance_variable_set(:@files, @files)
      counts = collection.counts
      
      counts[:total].should     == @file1_counts[:total] + @file2_counts[:total]
      counts[:empty].should     == @file1_counts[:empty] + @file2_counts[:empty]
      counts[:comments].should  == @file1_counts[:comments] + @file2_counts[:comments]
      counts[:code].should      == @file1_counts[:code] + @file2_counts[:code]
      counts[:files].should     == @files.count
    end
  end
end
