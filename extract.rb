#!/usr/bin/ruby
require 'rubygems'
require 'digest/md5'

require 'json' # gem install json_pure   
require 'itunes/library' # gem install itunes-library

library = 'small_library.xml'
#library = 'big_library.xml'

if not File.exist? library
	puts "Warning! Could not find library file: " + library
end

library = ITunes::Library.load(library)

tracks = Hash.new()

for i in library.tracks do
	# to_s avoids nil + string concatanation error
	name = i.name.to_s
	artist = i.artist.to_s
	genre = i.genre.to_s

	# Make an id to avoid track name conflicts
	id = Digest::MD5.hexdigest(name + artist + genre)
	
	tracks[id] = Hash['name'=>name, 'artist'=>artist, 'genre'=>genre]
end

File.open("temp.json","w") do |f|
  f.write(JSON.pretty_generate(tracks))
end