#!/usr/bin/ruby
require 'rubygems'
require 'pp'

require 'json'

LINKABLES = ['artist', 'genre', 'album']

input_file = ARGV[0]
output_file = ARGV[1]

if input_file == nil
	puts "Error: Please specify input file as first argument"
	Process.exit
end

if output_file == nil
	puts "Error: Please specify ouput file as second argument"
	Process.exit
end

if not File.exist? input_file
	puts "Error! Could not find input file: " + input_file
	Process.exit
end

input_data = JSON.parse(File.read(input_file))

nodes = []
links = []
network = {'nodes'=>nodes, 'links'=>links}

input_data.keys.each_with_index do |name, i| 
	# Create the nodes
	# TODO: find what group could be. It seems to translate
	# to color, so it could be a group per artist
	nodes.push({'name'=>name, 'group'=>0})

	# Create the links
	for j in (i+1)...input_data.keys.length
		value = 0
		source = input_data[input_data.keys[i]]
		target = input_data[input_data.keys[j]]
		for linkable in LINKABLES
			if source[linkable] == target[linkable]
				value += 1
			end
		end

		if value >= 1
			links.push({'source'=>i, 'target'=>j, 'value'=>value})
		end
	end
end

File.open(output_file,"w") do |f|
  f.write(JSON.pretty_generate(network))
end