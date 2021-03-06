#!/usr/bin/env ruby
require 'socket'
serial = (ARGV[0] == "--no-serial" ? false : true)

if serial
  require 'serialport'

  #params for serial port
  port_str = "/dev/ttyACM3"
  baud_rate = 9600
  data_bits = 8
  stop_bits = 1
  parity = SerialPort::NONE

  sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
end

trap("SIGINT") {exit!}

server = TCPServer.new 2000 # Server bind to port 2000
loop do
  client = server.accept    # Wait for a client to connect
  puts "Client connected..."
  while line = client.gets
    break if(line.chomp == "q")
    sp.write(line.chomp) if serial
    puts line.chomp.unpack("C*").join(",")

  end
  client.close
  puts "Client disconnected..."
end
