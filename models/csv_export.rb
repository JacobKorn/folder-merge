require 'csv'

class CSVExport

  def initialize(args)
    @compare = args.fetch(:compare)
    set_file_hashes
  end

  attr_reader :file_name

  def unchanged_files_csv
    CSV.generate do |csv|
      csv << ["Filename", "File Identifier (SHA1)"]
      unchanged_files.each do |file|
        csv << [file[:path], file[:sha1]]
      end
    end
  end

  def modified_files_csv
    CSV.generate do |csv|
      csv << ["Filename", "File Identifier (SHA1)"]
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

  def folder_1_new_files_csv
    CSV.generate do |csv|
      csv << ["Filename", "File Identifier (SHA1)"]
      folder_1_new_files.each do |file|
        csv << [file[:path], file[:sha1]]
      end
    end
  end

  def folder_2_new_files_csv
    CSV.generate do |csv|
      csv << ["Filename", "File Identifier (SHA1)"]
      folder_2_new_files.each do |file|
        csv << [file[:path], file[:sha1]]
      end
    end
  end

  private

  attr_reader :compare
  attr_accessor :unchanged_files, :modified_files, :moved_files, :folder_1_new_files, :folder_2_new_files

  def set_file_hashes
    self.unchanged_files = compare.unchanged_files
    self.modified_files = compare.modified_files
    self.moved_files = compare.moved_files
    self.folder_1_new_files = compare.folder_1_new_files
    self.folder_2_new_files = compare.folder_2_new_files
  end

end
