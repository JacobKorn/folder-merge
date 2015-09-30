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
    files_1.select do |sha_1, path_1|
      files_2.any? do |sha_2, path_2|
        compare_path(path_1, path_2) && compare_sha(sha_1, sha_2)
      end
    end
  end

  private

  attr_reader :files_1, :files_2, :same_sha, :same_path

  def compare_sha(sha_1, sha_2)
    if same_sha
      sha_2 == sha_1
    else
      sha_2 != sha_1
    end
  end

  def compare_path(path_1, path_2)
    if same_path
      path_2 == path_1
    else
      path_2 != path_1
    end
  end

end
