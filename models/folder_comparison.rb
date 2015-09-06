class FolderComparison

  def initialize(folder_1, folder_2)
    @folder_1 = folder_1
    @folder_2 = folder_2
    @folder_1_entries = FolderTree.analyse(folder_1)
    @folder_2_entries = FolderTree.analyse(folder_2)
  end

  def compare
    self.folder_1_files = remove_folders(folder_1_entries)
    self.folder_2_files = remove_folders(folder_2_entries)
  end

private
  
  attr_accessor :folder_1_files, :folder_2_files
  attr_reader :folder_1_entries, :folder_2_entries

  def remove_folders(entries)
    entries.select do |entry|
      entry[:folder] == false
    end
  end

end