require 'spec_helper'

describe LOCCounter::SourceFile do
  before(:each) do
    path = File.expand_path('../../fixtures/test.rb', __FILE__)
    @file = LOCCounter::SourceFile.new(path)
  end
  
  describe "#initialize" do
    before(:each) do
      @filename = stub("Filename")
      @lines = stub("Source lines")
      File.stub(:readlines).and_return(@lines)
    end
    
    context "with a non-existent file" do
      it "raises an ArgumentError" do
        expect {
          LOCCounter::SourceFile.new('foo')
        }.to raise_error(ArgumentError)
      end
    end
    
    context "with an existing file" do
      before(:each) do
        File.stub(:exists?).and_return(true)
      end
      
      it "puts the result of File.readlines to @lines" do
        File.should_receive(:readlines).with(@filename)
        file = LOCCounter::SourceFile.new(@filename)
        file.lines.should == @lines
      end
    end
  end
  
  describe "#counts" do
    before(:each) do
      @counts = @file.counts
      @lines  = @file.lines
    end
    
    describe "[:total]" do
      it "returns total lines count" do
        @counts[:total].should == @lines.count
      end
    end
    
    describe "[:empty]" do
      it "returns a number of empty lines" do
        empty_lines = @lines.find_all do |line|
          line =~ LOCCounter::SourceFile::EMPTY_PATTERN
        end
        
        @counts[:empty].should == empty_lines.count
      end
    end
    
    describe "[:comments]" do
      it "returns a number of lines containing just a comment" do
        comments_lines = @lines.find_all do |line|
          line =~ LOCCounter::SourceFile::COMMENT_PATTERN
        end
        
        @counts[:comments].should == comments_lines.count
      end
    end
    
    describe "[:code]" do
      it "returns a number of lines containing any code" do
        code_lines = @lines.reject do |line|
          line =~ LOCCounter::SourceFile::EMPTY_PATTERN || line =~ LOCCounter::SourceFile::COMMENT_PATTERN
        end
        
        @counts[:code].should == code_lines.count
      end
    end
  end
end
