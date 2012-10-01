#!/usr/bin/ruby
require 'itunes/library'

library = 'small_library.xml'

if not File.exist? library
	puts "Warning! Could not find library file: " + library
end

library = ITunes::Library.load(library)
puts library.playlists.map(&:name)


