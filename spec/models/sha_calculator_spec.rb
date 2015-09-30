require_relative '../include_helper'
require 'fileutils'

RSpec.describe SHACalculator, type: :model do

  let(:path) { "./spec/support/diverged_folders/files" }
  let(:second_path) { "/media/anthony/Seagate Backup Plus Drive/pmc-sync-folders-working-folders/Sales/Customers/Akl Customers" }


  describe ".file_shas" do
    it "calls file_shas"
  end

  describe "#file_shas" do

    it "returns a Hash" do
      folder_tree = FolderTree.new(path)
      expect(folder_tree.file_shas).to be_an(Hash)
    end

    it "it returns a Hash of { sha => path } structure" do
      folder_tree = FolderTree.new(path)
      result = folder_tree.file_shas
      expected_result = ["da39a3ee5e6b4b0d3255bfef95601890afd80709", "./spec/support/diverged_folders/files/empty_file.txt"]
      expect(result.first).to eq(expected_result)
    end
  end

end