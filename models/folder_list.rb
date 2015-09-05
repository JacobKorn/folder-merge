class FolderList

  def initialize(root_path)
    @root_path = root_path
    @file_paths = get_file_paths
  end

  attr_reader :file_paths

  def create_file_hash
    file_paths.zip(file_attributes).to_h
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
        folder_hash
      else
        file_hash(file)
      end
    end
  end

  def folder_hash
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