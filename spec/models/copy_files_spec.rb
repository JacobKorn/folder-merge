require_relative '../include_helper'
require 'fileutils'

RSpec.describe CopyFiles, type: :model do

  let(:first_path) { "./spec/support/diverged_folders/files" }
  let(:second_path) { "./spec/support/diverged_folders/files_diverged" }
  let(:compare) { FolderComparison.new(first_path, second_path) }

  describe "#copy_to_folder_1" do
    
    it "moves folder_2_new_files into folder_1"

  end

end