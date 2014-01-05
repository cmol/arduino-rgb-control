#!/usr/bin/env ruby

require 'audioinfo'
require 'serialport'

#params for serial port
port_str = "/dev/ttyACM3"
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

song_file = ARGV[0]

lamp = 3

song_length=0
AudioInfo.open(song_file) do |info|
  song_length = info.length   # playing time of the file
end

path_to_mood = "/tmp/lal.mood"

`moodbar -o #{path_to_mood} "#{song_file}"`


samples = []

s = File.binread(path_to_mood)
bytes = s.unpack("C*")

(1...1000).each do | sam |
  samples << [bytes[sam*3],bytes[sam*3+1],bytes[sam*3+2]]
end

fork {
  `mplayer "#{song_file}"`
}

sleep(0.250)

samples.each do | sample |
  s = sample
  lamp = (lamp == 3) ? 0 : lamp+1
  data = 0b00000001 | (lamp << 5)
  s.insert(0, data)
  s.insert(-1, 5)
  sp.write(s.pack("CCCCC"))

  puts s.join(",")
  sleep(song_length.to_f/1000)
end

sp.close
