class FolderComparison

  attr_reader :folder_1, :folder_2, :entries_1, :entries_2, :files_1, :files_2, :unchanged_files

  def initialize(folder_1, folder_2)
    @folder_1 = folder_1
    @folder_2 = folder_2
    @entries_1 = FolderTree.analyse(folder_1)
    @entries_2 = FolderTree.analyse(folder_2)
  end

  def prepare_folders
    self.files_1 = prepare_folder(entries_1, folder_1)
    self.files_2 = prepare_folder(entries_2, folder_2)
  end

  def unchanged_files
    @unchanged_files ||= files_1.select do |file_1|
      files_2.any? do |file_2|
        file_2[:path] == file_1[:path] &&
        file_2[:sha1] == file_1[:sha1]
      end
    end
  end

  def remove_unchanged_from_originals
    self.files_1 = files_1 - unchanged_files
    self.files_2 = files_2 - unchanged_files
  end

private

  attr_writer :files_1, :files_2, :unchanged_files

  def prepare_folder(entries, folder)
    files = remove_folders(entries)
    files = remove_root_name(files, folder)
  end

  def remove_root_name(files, folder)
    files.each do |file|
      file[:path].slice!(folder)
    end
  end

  def remove_folders(entries)
    entries.select do |entry|
      entry[:folder] == false
    end
  end


end