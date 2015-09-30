require_relative '../include_helper'
require 'fileutils'

RSpec.describe FolderEntries, type: :model do

  let(:path) { "./spec/support/diverged_folders/files" }

  it "#entry_paths returns an Array of entry paths" do
    folder_entries = FolderEntries.new(path)
    result = folder_entries.send(:entry_paths)
    expect(result).to be_an(Array)
    expect(result.count).to eq(6)
  end

  it "#folder_paths returns an Array of folder paths" do
    folder_entries = FolderEntries.new(path)
    expected_result = ["/subfolder"]
    expect(folder_entries.folder_paths).to eq(expected_result)
  end

  it "#file_paths returns an Array of file paths" do
    folder_entries = FolderEntries.new(path)
    expected_result = ["/empty_file.txt", "/subfolder/quote.txt", "/quote.txt", "/essay.txt", "/report.txt"]
    expect(folder_entries.file_paths).to eq(expected_result)
  end

end