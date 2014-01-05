#!/usr/bin/env ruby
require 'socket'

trap("SIGINT") {exit!}

server = TCPServer.new 2000 # Server bind to port 2000
loop do
  client = server.accept    # Wait for a client to connect
  while line = client.gets
    break if(line.chomp == "q")
    puts line.chomp.unpack("C*").map {|b| b.to_s(2)}.join("-")
    #line.chomp.unpack("C*").each do | byt |
    #  puts byt.to_s(2)
    #end

  end
  client.close
end
