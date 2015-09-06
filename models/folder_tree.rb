class FolderTree

  def self.analyse(root_path)
    result = new(root_path)
    result.analyse_tree
  end

  def initialize(root_path)
    @root_path = root_path
    @entries = []
  end
  
  def analyse_tree
    start_analysis
    entries.each do |entry|
      if entry[:folder]
        self.entries += FolderEntries.find_attributes(entry[:path])
      end
    end
    entries
  end

private

  attr_accessor :entries
  attr_reader :root_path
  
  def start_analysis
    self.entries = FolderEntries.find_attributes(root_path)
  end

end