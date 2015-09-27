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

    it "removes the duplicate files from the original files_1 hash" do
      expect(compare.files_1.count).to eq(4)
    end

    it "removes the duplicate files from the original files_2 hash" do
      expect(compare.files_1.count).to eq(4)
    end

  end

  describe "Unit Tests" do

    before do
      compare.send(:prepare_folders)
    end

    describe "#unchanged_files" do

      it "creates a hash of all the files with the same path and same SHA" do
        result = compare.unchanged_files.map { |a| a[:path]}
        expected_result = ["/subfolder/quote.txt"]
        expect(result).to eq(expected_result)
      end

    end

    describe "#modified_files" do

      it "creates a hash of modified files" do
        result = compare.modified_files.map { |a| a[:path]}
        expected_result = ["/essay.txt"]
        expect(result).to eq(expected_result)
      end

    end

    describe "#moved_files" do

      it "creates a hash of moved, renamed, and potentially duplicate files" do
        result = compare.moved_files
        expected_result = [{"29d6162f2e3927a7cfe95c0ee87adbbbae00da35"=>{:paths_1=>["/report.txt"], :paths_2=>["/renamed_report.txt"]}}]
        expect(result).to eq(expected_result)
      end

    end

    describe "#new_files" do

      it "creates a hash of new files for folder 1" do
        result = compare.folder_1_new_files.map { |a| a[:path]}
        expected_result = ["/empty_file.txt", "/quote.txt"]
        expect(result).to eq(expected_result)
      end
      
      it "creates a hash of new files for folder 2" do
        result = compare.folder_2_new_files.map { |a| a[:path]}
        expected_result = ["/newfile.txt", "/quote_2.txt"]
        expect(result).to eq(expected_result)
      end

    end

  end

end