#!/usr/bin/env ruby

require 'audioinfo'
require 'socket'
require '../mplayer-ruby/lib/mplayer-ruby'

sock = TCPSocket.new '172.16.0.5', 2000

song_file = ARGV[0]

lamp = 3

song_length=0
AudioInfo.open(song_file) do |info|
  song_length = info.length   # playing time of the file
end

path_to_mood = "/tmp/lal.mood"

puts "Generating moodbar.."
`moodbar -o #{path_to_mood} "#{song_file}"`


samples = []

s = File.binread(path_to_mood)
bytes = s.unpack("C*")

puts "Reading .mood file.."
(1...1000).each do | sam |
  samples << [bytes[sam*3],bytes[sam*3+1],bytes[sam*3+2]].map{ |x| x==10 ? 11 : x }
end

player = MPlayer::Slave.new(song_file)

sleep(0.250)

samples.each do | sample |
  lamp = (lamp == 3) ? 0 : lamp+1
  data = 0b00000001 | (lamp << 5)
  sample.insert(0, data)
  sample.insert(-1, 5)
  sock.puts(sample.pack("CCCCC"))

  puts sample.join(",")
  sleep(song_length.to_f/1000)
end

sock.close
