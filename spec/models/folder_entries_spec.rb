require_relative '../include_helper'
require 'fileutils'

RSpec.describe FolderEntries, type: :model do

  let(:path) { "./spec/support/diverged_folders/files" }

  it "#entry_paths returns an Array of folder paths" do
    folder_entries = FolderEntries.new(path)
    result = folder_entries.send(:entry_paths)
    expect(result).to be_an(Array)
  end

  it "#entries_hash returns a hash of entries" do
    folder_entries = FolderEntries.new(path)
    expected_result = {"./spec/support/diverged_folders/files/empty_file.txt"=>{:folder=>false, :sha1=>"da39a3ee5e6b4b0d3255bfef95601890afd80709"}, "./spec/support/diverged_folders/files/subfolder"=>{:folder=>true, :scanned=>false}, "./spec/support/diverged_folders/files/quote.txt"=>{:folder=>false, :sha1=>"c506e2c74c23db4db01e2b4133483ce098408f42"}, "./spec/support/diverged_folders/files/essay.txt"=>{:folder=>false, :sha1=>"15b892a2bd36681203e3c2ec61ca2ce5ddc7a418"}, "./spec/support/diverged_folders/files/report.txt"=>{:folder=>false, :sha1=>"29d6162f2e3927a7cfe95c0ee87adbbbae00da35"}}
    expect(folder_entries.entries_hash).to eq(expected_result)
  end

  it "#folders_hash only contains folders" do
    folder_entries = FolderEntries.new(path)
    result = folder_entries.folders_hash.any? do |path, meta|
      meta[:folder] == false
    end
    expect(result).to eq(false)
  end

  it "#files_hash only contains files" do
    folder_entries = FolderEntries.new(path)
    result = folder_entries.files_hash.any? do |path, meta|
      meta[:folder] == true
    end
    expect(result).to eq(true)
  end

end