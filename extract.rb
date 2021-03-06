#!/usr/bin/ruby
require 'rubygems'
require 'bundler/setup'
require 'digest'
require 'optparse'

require 'json' 			 # gem install json_pure   
require 'itunes/library' # gem install itunes-library

SAMPLE_SIZE = 0.1

# Read in the input file and output from the command line
library_file = ARGV[0]
output_file = ARGV[1]

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: extract.rb [options] input_file output_file"
  opts.on("-s", "--[no-]sample", "Sample tracks") do |s|
    options[:sample] = s
  end
end.parse!

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

puts "Reading... " + library_file
library = ITunes::Library.load(library_file)

tracks = Hash.new()

for i in library.tracks do
	if options[:sample] != true or rand() <= SAMPLE_SIZE
		# to_s avoids nil + string concatanation error
		name = i.name.to_s
		artist = i.artist.to_s
		genre = i.genre.to_s
		album = i.album.to_s

		# Make an id to avoid track name conflicts
		id = Digest::MD5.hexdigest(name + artist + genre + album)
		
		tracks[id] = Hash['name'=>name,
						  'artist'=>artist,
						  'genre'=>genre,
						  'album'=>album]
	end
end

puts "Writing... " + output_file
File.open(output_file,"w") do |f|
  f.write(JSON.pretty_generate(tracks))
end

