require_relative '../include_helper'
require 'fileutils'

RSpec.describe CSVExport, type: :model do

  let(:first_path) { "./spec/support/diverged_folders/files" }
  let(:second_path) { "./spec/support/diverged_folders/files_diverged" }
  let(:compare) { FolderComparison.new(first_path, second_path) }
  let(:csv_dir) { "./spec/generated_csv_files" }
  let(:csv_export) { CSVExport.new(compare: compare, csv_dir: csv_dir) }

  describe "integration" do

    it "creates all csv files" do
      Dir.mkdir(csv_dir) unless Dir.exists?(csv_dir)
      csv_export.export_csv
      result = Dir.entries(csv_dir)
      expected_result = [".", "..", "folder_1_new_files.csv", "folder_2_new_files.csv", "modified_files.csv", "moved_files.csv", "unchanged_files.csv"]
      expected_result.each do |file|
        expect(result).to include(file)
      end
      FileUtils.rm_rf(csv_dir)
    end

  end

  describe "#generate csv strings" do

    it "generates csv string for unchanged files" do
      result = csv_export.send(:unchanged_files_csv)
      expected_result = "File Identifier (SHA1),Filename\n834810faf5ca14899d23b2e98fee1f6f2066cc17,/subfolder/quote.txt\n"
      expect(result).to eq(expected_result)
    end

    it "generates csv string for modified files" do
      result = csv_export.send(:modified_files_csv)
      expected_result = "File Identifier (SHA1),Filename\n15b892a2bd36681203e3c2ec61ca2ce5ddc7a418,/essay.txt\n"
      expect(result).to eq(expected_result)
    end

    it "generates csv string for moved files" do
      result = csv_export.send(:moved_files_csv)
      expected_result = "File Identifier (SHA1),Folder One Paths,Folder Two Paths\n29d6162f2e3927a7cfe95c0ee87adbbbae00da35,/report.txt,/renamed_report.txt\n"
      expect(result).to eq(expected_result)
    end

    it "generates csv string for folder 1's new files" do
      result = csv_export.send(:folder_1_new_files_csv)
      expected_result = "File Identifier (SHA1),Filename\nda39a3ee5e6b4b0d3255bfef95601890afd80709,/empty_file.txt\nc506e2c74c23db4db01e2b4133483ce098408f42,/quote.txt\n"
      expect(result).to eq(expected_result)
    end

    it "generates csv string for folder 2's new files" do
      result = csv_export.send(:folder_2_new_files_csv)
      expected_result = "File Identifier (SHA1),Filename\na77b0882841c633011478420bf0eb9d10f39fd1b,/newfile.txt\n81716d71d16f5a5f9293bb8eb4d224b4b806484e,/quote_2.txt\n"
      expect(result).to eq(expected_result)
    end

  end


end
