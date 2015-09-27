class CompareTree

  def self.compare(args)
    compare_tree = new(args)
    compare_tree.compare
  end

  def initialize(args)
    @same_sha = args.fetch(:same_sha)
    @same_path = args.fetch(:same_path)
    @files_1 = args.fetch(:files_1)
    @files_2 = args.fetch(:files_2)
  end

  def compare
    files_1.select do |file_1|
      files_2.any? do |file_2|
        compare_path(file_1, file_2) && compare_sha(file_1, file_2)
      end
    end
  end

  private

  attr_reader :files_1, :files_2, :same_sha, :same_path

  def compare_sha(file_1, file_2)
    if same_sha
      file_2[:sha1] == file_1[:sha1]
    else
      file_2[:sha1] != file_1[:sha1]
    end
  end

  def compare_path(file_1, file_2)
    if same_path
      file_2[:path] == file_1[:path]
    else
      file_2[:path] != file_1[:path]
    end
  end

end
