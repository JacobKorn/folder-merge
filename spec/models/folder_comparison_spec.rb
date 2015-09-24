require_relative '../include_helper'

RSpec.describe FolderComparison, type: :model do

  let(:first_path) { "./spec/support/diverged_folders/files" }
  let(:second_path) { "./spec/support/diverged_folders/files_diverged" }
  let(:compare) { FolderComparison.new(first_path, second_path) }

  it "creates an entries hash containing files and folders" do
    result = compare.entries_1.map{ |a| a[:folder] }.uniq
    expect(result).to include(true, false)
  end

  describe "#run_comparison" do

    before do
      compare.run_comparison
    end

    it "removes folders from the entries hash" do
      result = compare.files_1.map { |file| file[:folder] }.uniq.first
      expect(result).to eq(false)
    end

    it "removes the root portion of file paths" do
      result = compare.files_1.map { |file| file[:path].include?(compare.folder_1) }.uniq.first
      expect(result).to eq(false)
    end

    it "creates a hash of all the files with the same path and same SHA" do
      result = compare.unchanged_files
      expect(result.count).to eq(1)
    end

    it "removes the duplicate files from the original files_1 hash" do
      expect(compare.files_1.count).to eq(4)
    end

    it "removes the duplicate files from the original files_2 hash" do
      expect(compare.files_1.count).to eq(4)
    end

    it "creates a hash of modified files" do
      expect(compare.modified_files.count).to eq("")
    end

    it "creates a hash of moved files" do
      expect(compare.moved_files.count).to eq("")
    end

    it "creates a hash of new files" do
      expect(compare.new_files.count).to eq("")
    end
  end  

end