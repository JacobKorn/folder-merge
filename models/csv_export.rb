require 'csv'
require 'fileutils'

class CSVExport

  STANDARD_HEADER = ["Filename", "File Identifier (SHA1)"]
  MOVED_FILES_HEADER = [ "File Identifier (SHA1)", "Folder One Paths", "Folder Two Paths"]

  def initialize(args)
    @compare = args.fetch(:compare)
    @csv_dir = args.fetch(:csv_dir, "./csv_files")
    set_file_hashes
  end

  attr_reader :file_name

  def export_csv
    FileUtils.mkdir_p(csv_dir) unless Dir.exists?(csv_dir)
    write_csv("unchanged_files.csv", unchanged_files_csv)
    write_csv("modified_files.csv", modified_files_csv)
    write_csv("moved_files.csv", moved_files_csv)
    write_csv("folder_1_new_files.csv", folder_1_new_files_csv)
    write_csv("folder_2_new_files.csv", folder_2_new_files_csv)
  end

  private

  attr_reader :compare, :csv_dir
  attr_accessor :unchanged_files, :modified_files, :moved_files, :folder_1_new_files, :folder_2_new_files

  def write_csv(file_name, csv_string)
    unless csv_string == "#{STANDARD_HEADER.join(",")}\n" || csv_string == "#{MOVED_FILES_HEADER.join(",")}\n"
      File.open("./#{csv_dir}/#{file_name}", "w") do |file|
        file.write(csv_string)
      end
    end
  end

  def unchanged_files_csv
    CSV.generate do |csv|
      csv << STANDARD_HEADER
      unchanged_files.each do |file|
        csv << [file[:path], file[:sha1]]
      end
    end
  end

  def modified_files_csv
    CSV.generate do |csv|
      csv << STANDARD_HEADER
      modified_files.each do |file|
        csv << [file[:path], file[:sha1]]
      end
    end
  end

  def moved_files_csv
    CSV.generate do |csv|
      csv << MOVED_FILES_HEADER
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
      csv << STANDARD_HEADER
      folder_1_new_files.each do |file|
        csv << [file[:path], file[:sha1]]
      end
    end
  end

  def folder_2_new_files_csv
    CSV.generate do |csv|
      csv << STANDARD_HEADER
      folder_2_new_files.each do |file|
        csv << [file[:path], file[:sha1]]
      end
    end
  end

  def set_file_hashes
    self.unchanged_files = compare.unchanged_files
    self.modified_files = compare.modified_files
    self.moved_files = compare.moved_files
    self.folder_1_new_files = compare.folder_1_new_files
    self.folder_2_new_files = compare.folder_2_new_files
  end

end
