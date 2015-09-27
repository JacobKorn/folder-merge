require 'csv'

class CSVExport

  def initialize(args)
    @compare = args.fetch(:compare)
    set_file_hashes
  end

  attr_reader :file_name

  def unchanged_files_csv
    CSV.generate do |csv|
      csv << ["filename", "file identifier (sha1)"]
      unchanged_files.each do |file|
        csv << [file[:path], file[:sha1]]
      end
    end
  end

  def modified_files_csv
    CSV.generate do |csv|
      csv << ["filename", "file identifier (sha1)"]
      modified_files.each do |file|
        csv << [file[:path], file[:sha1]]
      end
    end
  end

  def moved_files_csv
    CSV.generate do |csv|
      csv << [ "File Identifier (SHA1)", "Folder One Paths", "Folder Two Paths"]
      moved_files.each do |file|
        csv << [
          file.keys.first,
          file.values.first[:paths_1].join(", "),
          file.values.first[:paths_2].join(", ")
        ]
      end
    end
  end

  private

  attr_reader :compare
  attr_accessor :unchanged_files, :modified_files, :moved_files

  def set_file_hashes
    self.unchanged_files = compare.unchanged_files
    self.modified_files = compare.modified_files
    self.moved_files = compare.moved_files
  end

end
