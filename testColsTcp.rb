#!/usr/bin/env ruby
require 'socket'

sock = TCPSocket.new '172.16.0.26', 2000

(0..5).each do |b|
  (0..5).each do |g|
    (0..5).each do |r|
      data = [0b10000000, r*51, g*51, b*51]
      sock.puts(data.pack("CCCC"))
      puts "#{r*51} #{g*51} #{b*51}"
      sleep(0.1)
    end
  end
end
