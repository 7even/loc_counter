require 'spec_helper'

describe LOCCounter::Project do
  before(:each) do
    stub_files
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
end
