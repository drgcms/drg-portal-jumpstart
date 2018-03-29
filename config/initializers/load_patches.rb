
#require 'patches/some_patch.rb' # patches are normally located in libs/patches directory

DrgCms::add_patches_path(File.expand_path("../../../lib/patches", __FILE__))
