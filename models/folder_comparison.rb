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
      if sha_exists_in_file_list?(sha, folder)
        false
      elsif path_exists_in_file_list?(paths, folder)
        false
      else
        true
      end
    end
  end

  def sha_exists_in_file_list?(sha, files)
    !files[sha].empty?
  end

  def path_exists_in_file_list?(paths, files)
    files_array = files.values.flatten
    paths.any? do |path|
      files_array.include?(path)
    end
  end

  def find_path_in_files(paths_to_check, files)
    files.select do |sha, paths|
      paths.include?(paths_to_check)
    end
  end

  def find_sha_in_files(sha_to_check, files)
    files.select do |sha, paths|
      sha == sha_to_check
    end
  end

  def remove_unchanged_from_originals
    unchanged_files.keys.each do |sha|
      files_1.delete(sha)
      files_2.delete(sha)
    end
  end

  def remove_modified_from_originals
    modified_files.keys.each do |sha|
      files_1.delete(sha)
      files_2.delete(sha)
    end
  end

end
