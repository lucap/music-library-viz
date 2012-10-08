#!/usr/bin/ruby
require 'rubygems'
require 'digest/md5'

require 'json' # gem install json_pure   
require 'itunes/library' # gem install itunes-library

# Read in the input file and output from the command line
library_file = ARGV[0]
output_file = ARGV[1]

if library_file == nil
	puts "Error: Please specify input library path as first argument"
	Process.exit
end

if output_file == nil
	puts "Error: Please specify ouput file as second argument"
	Process.exit
end

if not File.exist? library_file
	puts "Error! Could not find library file: " + library_file
	Process.exit
end

library = ITunes::Library.load(library_file)

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

