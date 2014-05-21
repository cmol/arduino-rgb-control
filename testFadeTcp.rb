#!/usr/bin/env ruby
require 'socket'
require 'json'

config = JSON.parse(File.read('config.json'))
sock = TCPSocket.new config["address"], config["port"]

loop do
  puts "Input color and fadetime: (\"0-255 0-255 0-255 0-255\") (q to quit)"
  cols = $stdin.gets.chomp
  exit(0) if (cols == "q")
  cols = cols.split(" ")
  data = [0b10000001, cols[0].to_i, cols[1].to_i, cols[2].to_i, cols[3].to_i]
  sock.puts(data.pack("CCCCC"))
end
