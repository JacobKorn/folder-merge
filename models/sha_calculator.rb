class SHACalculator

  def self.file_shas(root_path)
    result = new(root_path)
    result.file_shas
  end

  attr_reader :file_shas

  def initialize(root_path)
    @root_path = root_path
    @file_shas = Hash.new { |h,k| h[k] = [] }
    get_paths
    build_shas
  end

private

  attr_accessor :folder_paths, :file_paths
  attr_reader :root_path
  
  def get_paths
    self.folder_paths, self.file_paths = FolderEntries.folders_and_files(root_path)
    folder_paths
  end

  def build_shas
    file_paths.map do |path|
      self.file_shas[sha(path)] << path
    end
  end

  def sha(path)
    Digest::SHA1.hexdigest(IO.read(root_path + path))
  end

end