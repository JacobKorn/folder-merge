require_relative '../include_helper'
require 'fileutils'

RSpec.describe FolderEntries, type: :model do

  let(:path) { "./spec/support/diverged_folders/files" }
  let(:second_path) { "/media/anthony/Seagate Backup Plus Drive/pmc-sync-folders-working-folders/Sales/Customers/Akl Customers" }

  it "#entry_paths returns an Array of folder paths" do
    folder_entries = FolderEntries.new(path)
    result = folder_entries.send(:entry_paths)
    expect(result).to be_an(Array)
  end

  it "#entries_hash returns a hash of entries" do
    folder_entries = FolderEntries.new(path)
    expected_result = {"./spec/support/diverged_folders/files/subfolder"=>{:folder=>true, :scanned=>false}}
    expect(folder_entries.entries_hash).to eq(expected_result)
  end

end