require 'digest/sha1'
require_relative 'models/folder_entries'
require_relative 'models/folder_tree'
require 'pry-byebug'

root_path = "/media/anthony/Seagate Backup Plus Drive/pmc-sync-folders-working-folders/Management/Accounting/Angela Accounting/"

f = FolderTree.new(root_path)
p f.analyse_tree
