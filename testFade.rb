#!/usr/bin/env ruby
require 'serialport' # use Kernel::require on windows, works better 

#params for serial port
port_str = "/dev/ttyACM3"  #may be different for you
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
puts "Sleeping for borad to become active"
sleep(1)

loop do
  puts "Input color and fadetime: (\"0-255 0-255 0-255 0-255\") (q to quit)"
  cols = $stdin.gets.chomp
  exit(0) if (cols == "q")
  cols = cols.split(" ")
  data = [0b10000001, cols[0].to_i, cols[1].to_i, cols[2].to_i, cols[3].to_i]
  sp.write(data.pack("CCCCC"))
end
