#!/usr/bin/env ruby
require 'socket'

sock = TCPSocket.new '172.16.0.23', 2000

loop do
  puts "Input color and fadetime: (\"0-128\") (q to quit)"
  time = $stdin.gets.chomp
  exit(0) if (time == "q")
  data = [0b10001010, time.to_i]
  sock.puts(data.pack("CC"))
end
