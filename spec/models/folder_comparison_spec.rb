require_relative '../include_helper'

RSpec.describe FolderComparison, type: :model do

  let(:first_path) { "/media/anthony/Seagate Backup Plus Drive/pmc-sync-folders-working-folders/Management/Accounting/Angela Accounting/" }
  let(:second_path) { "/media/anthony/Seagate Backup Plus Drive/pmc-sync-folders-working-folders/Management/Accounting/Frank Accounting" }
  let(:compare) { FolderComparison.new(first_path, second_path) }

  it "creates an entries hash containing files and folders" do
    result = compare.entries_1.map{ |a| a[:folder] }.uniq
    expect(result).to eq([true, false])
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
      expect(result.count).to eq(83)
    end

    it "removes the duplicate files from the original hashes" do
      expect(compare.files_1.count).to eq(2)
      expect(compare.files_2.count).to eq(1)
    end

    it "creates a hash of modified files" do

    end

  end  

end