require 'spec_helper'

describe LOCCounter::Project do
  before(:each) do
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
    
    @dir_path = '/path/to/project'
  end
  
  describe "#initialize" do
    context "with a non-existent directory" do
      it "raises an ArgumentError" do
        expect {
          LOCCounter::Project.new('foo')
        }.to raise_error(ArgumentError)
      end
    end
    
    context "with an existing directory" do
      before(:each) do
        File.stub(:exists?).and_return(true)
        Dir.stub(:glob).and_return(@filenames)
      end
      
      it "puts the files list from Dir.glob to @files" do
        Dir.should_receive(:glob).with(@dir_path + '/' + LOCCounter::Project::SOURCE_FILES.first)
        project = LOCCounter::Project.new(@dir_path)
        project.files.should == [@file1, @file2] * LOCCounter::Project::SOURCE_FILES.count
      end
    end
  end
  
  describe "#counts" do
    before(:each) do
      File.stub(:exists?).and_return(true)
      
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
      project = LOCCounter::Project.new(@dir_path)
      project.instance_variable_set(:@files, @files)
      counts = project.counts
      
      counts[:total].should     == @file1_counts[:total] + @file2_counts[:total]
      counts[:empty].should     == @file1_counts[:empty] + @file2_counts[:empty]
      counts[:comments].should  == @file1_counts[:comments] + @file2_counts[:comments]
      counts[:code].should      == @file1_counts[:code] + @file2_counts[:code]
      counts[:files].should     == @files.count
    end
  end
end
