#!/usr/bin/env ruby
require 'socket'
require 'json'

config = JSON.parse(File.read('config.json'))
sock = TCPSocket.new config["address"], config["port"]

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
