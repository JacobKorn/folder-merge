require_relative '../include_helper'

RSpec.describe FolderComparison, type: :model do

  describe "#remove_folders" do

    let(:first_path) { "/media/anthony/Seagate Backup Plus Drive/pmc-sync-folders-working-folders/Management/Accounting/Angela Accounting/" }
    let(:second_path) { "/media/anthony/Seagate Backup Plus Drive/pmc-sync-folders-working-folders/Management/Accounting/Marilyn Accounting" }
    let(:compare) { FolderComparison.new(first_path, second_path) }

    it "entries hash has files and folders" do
      compare.compare
      result = compare.folder_1_entries.map{ |a| a[:folder] }.uniq
      expect(result).to eq([true, false])

    end

    it "files hash only has files" do
      compare.compare
      result = compare.folder_1_files.map { |a| a[:folder] }.uniq
      expect(result).to eq([false])
    end

  end

end