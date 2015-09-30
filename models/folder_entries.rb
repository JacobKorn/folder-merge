class FolderEntries

  def self.entries_hash(root_path)
    folder_entries = new(root_path)
    folder_entries.entries_hash
  end

  def self.folder_and_files_hahses(root_path)
    folder_entries = new(root_path)
    [folder_entries.folders_hash, folder_entries.files_hash]
  end

  def initialize(root_path)
    @entries = {}
    @root_path = root_path
  end

  def folders_hash
    entries_hash.select do |path, meta|
      meta[:folder]
    end
  end

  def files_hash
    entries_hash.select do |path, meta|
      meta[:folder] == false
    end
  end

  def entries_hash
    @entries_hash ||= populate_entries_hash
  end

private

  attr_accessor :entries
  attr_reader :root_path

  def entry_paths
    @entry_paths ||= populate_entry_paths
  end

  def populate_entry_paths
    file_names = Dir.entries(root_path)
    file_names.delete(".")
    file_names.delete("..")
    file_names.map { |entry| "#{root_path}/#{entry}"}
  end

  def populate_entries_hash
    entry_paths.each do |file|
      if File.directory?(file)
        entries[file] = folder_hash(file)
      else
        entries[file] = file_hash(file)
      end
    end
    entries
  end

  def folder_hash(folder)
    {
      folder: true,
      scanned: false
    }
  end

  def file_hash(file)
    {
      folder: false,
      sha1: Digest::SHA1.hexdigest(IO.read(file))
    }
  end

end