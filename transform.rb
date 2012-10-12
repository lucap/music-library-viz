#!/usr/bin/ruby
require 'rubygems'
require 'pp'

require 'json'

input_file = ARGV[0]

if input_file == nil
	puts "Error: Please specify input file as first argument"
	Process.exit
end


input_data = JSON.parse(File.read(input_file))

pp input_data

nodes = []
links = []

input_data.each_pair do |k,v| 
	nodes.push({'name'=>k, 'group'=>0})
	# TODO: loop through the keys only by index	
end

pp nodes