class FolderComparison

  attr_reader :folder_1, :folder_2, :files_1, :files_2, :unchanged_files

  def self.compare_and_export(folder_1, folder_2, csv_dir)
    folder_comparison = new(folder_1, folder_2)
    folder_comparison.run_comparison
    csv_export = CSVExport.new(compare: folder_comparison, csv_dir: csv_dir)
    csv_export.export_csv
  end

  def self.compare_export_and_copy(folder_1, folder_2, csv_dir)
    folder_comparison = new(folder_1, folder_2)
    folder_comparison.run_comparison
    csv_export = CSVExport.new(compare: folder_comparison, csv_dir: csv_dir)
    csv_export.export_csv
    copy_files = CopyFiles.new(compare: folder_comparison, folder_1: folder_1, folder_2: folder_2)
    copy_files.copy_to_folder_1
  end

  def initialize(folder_1, folder_2)
    @folder_1 = folder_1
    @folder_2 = folder_2
    @files_1 = SHACalculator.file_shas(folder_1)
    @files_2 = SHACalculator.file_shas(folder_2)
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
    @files_1_moved.map do |sha, path|
      {
        sha => {
          paths_1: files_1[sha],
          paths_2: files_2[sha]
        }
      }
    end
  end

  def folder_1_new_files
    files_not_in_folder(files_1, files_2)
  end

  def folder_2_new_files
    # no matching path or sha
    files_not_in_folder(files_2, files_1)
  end

private

  attr_writer :files_1, :files_2, :unchanged_files

  def files_not_in_folder(files, folder)
    files.select do |sha, paths|
      path_blank = find_path_in_files(file[:path], folder).empty?
      sha_blank = find_sha_in_files(file[:sha1], folder).empty?
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

  def remove_unchanged_from_originals
    self.files_1 = files_1 - unchanged_files
    self.files_2 = files_2 - unchanged_files
  end

  def remove_modified_from_originals
    self.files_1 = files_1 - modified_files
    self.files_2 = files_2 - modified_files
  end

end
