#!/usr/bin/env ruby
require 'socket'
require 'json'

config = JSON.parse(File.read('config.json'))
sock = TCPSocket.new config["address"], config["port"]

loop do
  puts "Input color and fadetime: (\"0-128\") (q to quit)"
  time = $stdin.gets.chomp
  exit(0) if (time == "q")
  data = [0b10001010, time.to_i]
  sock.puts(data.pack("CC"))
end
