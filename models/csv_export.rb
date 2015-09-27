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

  private

  attr_reader :compare
  attr_accessor :unchanged_files, :modified_files

  def set_file_hashes
    self.unchanged_files = compare.unchanged_files
    self.modified_files = compare.modified_files
  end

end