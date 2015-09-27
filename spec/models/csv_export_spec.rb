require_relative '../include_helper'

RSpec.describe CSVExport, type: :model do

  let(:first_path) { "./spec/support/diverged_folders/files" }
  let(:second_path) { "./spec/support/diverged_folders/files_diverged" }
  let(:compare) { FolderComparison.new(first_path, second_path) }
  let(:csv_export) { CSVExport.new(compare: compare) }

  describe "#generate csv strings" do

    before do
      compare.run_comparison
    end

    it "generates csv string for unchanged files" do
      result = csv_export.unchanged_files_csv
      expected_result = "Filename,File Identifier (SHA1)\n/subfolder/quote.txt,834810faf5ca14899d23b2e98fee1f6f2066cc17\n"
      expect(result).to eq(expected_result)
    end

    it "generates csv string for modified files" do
      result = csv_export.modified_files_csv
      expected_result = "Filename,File Identifier (SHA1)\n/essay.txt,15b892a2bd36681203e3c2ec61ca2ce5ddc7a418\n"
      expect(result).to eq(expected_result)
    end

    it "generates csv string for moved files" do
      result = csv_export.moved_files_csv
      expected_result = "File Identifier (SHA1),Folder One Paths,Folder Two Paths\n29d6162f2e3927a7cfe95c0ee87adbbbae00da35,/report.txt,/renamed_report.txt\n"
      expect(result).to eq(expected_result)
    end

    it "generates csv string for folder 1's new files" do
      result = csv_export.folder_1_new_files_csv
      expected_result = "Filename,File Identifier (SHA1)\n/empty_file.txt,da39a3ee5e6b4b0d3255bfef95601890afd80709\n/quote.txt,c506e2c74c23db4db01e2b4133483ce098408f42\n"
      expect(result).to eq(expected_result)
    end

    it "generates csv string for folder 2's new files" do
      result = csv_export.folder_2_new_files_csv
      expected_result = "Filename,File Identifier (SHA1)\n/newfile.txt,a77b0882841c633011478420bf0eb9d10f39fd1b\n/quote_2.txt,81716d71d16f5a5f9293bb8eb4d224b4b806484e\n"
      expect(result).to eq(expected_result)
    end

  end


end
