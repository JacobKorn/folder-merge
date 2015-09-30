class FolderEntries

  def self.folders_and_files(root_path)
    folder_entries = new(root_path)
    [folder_entries.folder_paths, folder_entries.file_paths]
  end

  attr_reader :folder_paths, :file_paths

  def initialize(root_path)
    @root_path = root_path
    @folder_paths = []
    @file_paths = []
    populate_paths
  end

private

  attr_reader :root_path
  attr_writer :folder_paths, :file_paths


  def entry_paths
    @entry_paths ||= Dir.glob(root_path + "/**/*")
  end

  def populate_paths
    entry_paths.each do |entry_path|
      if File.directory?(entry_path)
        self.folder_paths << remove_root_path(entry_path)
      else
        self.file_paths << remove_root_path(entry_path)
      end
    end
  end

  def remove_root_path(path)
    path.split(root_path).last
  end

end