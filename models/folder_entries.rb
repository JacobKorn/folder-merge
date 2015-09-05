class FolderEntries

  def self.find_attributes(root_path)
    folder_entries = new(root_path)
    folder_entries.find_attributes
  end

  def initialize(root_path)
    @root_path = root_path
    @file_paths = get_file_paths
  end

  attr_reader :file_paths

  def find_attributes
    file_attributes
  end

private

  attr_reader :root_path

  def get_file_paths
    file_names = Dir.entries(root_path)
    file_names.delete(".")
    file_names.delete("..")
    file_names.map { |entry| "#{root_path}/#{entry}"}
  end

  def file_attributes
    file_paths.map do |file|
      if File.directory?(file)
        folder_hash(file)
      else
        file_hash(file)
      end
    end
  end

  def folder_hash(folder)
    {
      path: folder,
      folder: true,
      scanned: false
    }
  end

  def file_hash(file)
    {
      path: file,
      folder: false,
      sha1: Digest::SHA1.hexdigest(IO.read(file))
    }
  end

end