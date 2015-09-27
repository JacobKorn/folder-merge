class FolderComparison

  attr_reader :folder_1, :folder_2, :entries_1, :entries_2, :files_1, :files_2, :unchanged_files

  def initialize(folder_1, folder_2)
    @folder_1 = folder_1
    @folder_2 = folder_2
    @entries_1 = FolderTree.analyse(folder_1)
    @entries_2 = FolderTree.analyse(folder_2)
  end

  def run_comparison
    prepare_folders
    remove_unchanged_from_originals
    # remove_modified_from_originals
  #   remove_moved_from_originals
  #   remove_new_from_originals
  end

  def unchanged_files
    # same path same sha
    @unchanged_files ||= CompareTree.compare(
      same_path: true,
      same_sha: true,
      files_1: files_1,
      files_2: files_2
    )
  end

  def modified_files
    # Same path different sha
    @modified_files ||= CompareTree.compare(
      same_path: true,
      same_sha: false,
      files_1: files_1,
      files_2: files_2
    )
  end

  def moved_files
    # different path same sha
    @files_1_moved ||= CompareTree.compare(
      same_path: false,
      same_sha: true,
      files_1: files_1,
      files_2: files_2
    )
    @files_1_moved.map do |moved_file|
      {
        moved_file[:sha1] => {
          paths_1: find_path_by_sha(moved_file[:sha1], files_1),
          paths_2: find_path_by_sha(moved_file[:sha1], files_2)
        }
      }
    end
  end

  def folder_1_new_files
    # no matching path or sha
    # @new_files ||= CompareTree.compare(
    #   same_path: false,
    #   same_sha: false,
    #   files_1: files_1,
    #   files_2: files_2
    # )

    files_1.select do |file_1|
      path_blank = find_path_in_files(file_1[:path], files_2).empty?
      sha_blank = find_sha_in_files(file_1[:sha1], files_2).empty?
      true if path_blank && sha_blank
    end

  end

  def find_path_in_files(path, files)
    files.select do |file|
      file[:path] == path
    end
  end

  def find_sha_in_files(sha, files)
    files.select do |file|
      file[:sha1] == sha
    end
  end

  def match_diff_path_diff_sha(file, files)
    files.any? do |file_2|
      file[:sha1] != file_2[:sha1] && file[:path] != file_2[:path]
    end
  end

  def folder_2_new_files
    # no matching path or sha
    files_2.select do |file_2|
      path_blank = find_path_in_files(file_2[:path], files_1).empty?
      sha_blank = find_sha_in_files(file_2[:sha1], files_1).empty?
      true if path_blank && sha_blank
    end
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

  def prepare_folders
    self.files_1 = prepare_folder(entries_1, folder_1)
    self.files_2 = prepare_folder(entries_2, folder_2)
  end

  def remove_unchanged_from_originals
    self.files_1 = files_1 - unchanged_files
    self.files_2 = files_2 - unchanged_files
  end

  def find_path_by_sha(sha, files)
    files.map do |file|
      file[:path] if file[:sha1] == sha
    end.compact
  end

end
