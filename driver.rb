require 'digest/sha1'
require_relative 'models/folder_list'
require 'pry-byebug'

f = FolderList.new(Dir.pwd)
p f.file_paths
binding.pry
p f.create_file_hash