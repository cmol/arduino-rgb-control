#!/usr/bin/env ruby

require 'audioinfo'
require 'socket'
require '../mplayer-ruby/lib/mplayer-ruby'
require 'json'
require 'digest'

config = JSON.parse(File.read('config.json'))
sock = TCPSocket.new config["address"], config["port"]

song_file = ARGV[0]

lamp = 3

song_length=0
md5 = ""
AudioInfo.open(song_file) do |info|
  song_length = info.length   # playing time of the file
  md5 = Digest::MD5.hexdigest "#{info.artist+info.album+info.length.to_s+info.title}"
end

path_to_mood = "/tmp/#{md5}.mood"

unless File.exist?(path_to_mood) && File.size(path_to_mood) == 3000
  print "Generating moodbar.."
  `moodbar -o #{path_to_mood} "#{song_file}"`
end

print "\r   R   G   B        \n"

samples = []

s = File.binread(path_to_mood)
bytes = s.unpack("C*")

# Read the mood file
(1...1000).each do | sam |
  samples << [bytes[sam*3],bytes[sam*3+1],bytes[sam*3+2]].map{ |x| x==10 ? 11 : x }
end

player = MPlayer::Slave.new(song_file)

samples.each do | sample |
  lamp = (lamp == 3) ? 0 : lamp+1
  data = 0b00000001 | (lamp << 5)
  sample.insert(0, data)
  sample.insert(-1, 5)
  sock.puts(sample.pack("CCCCC"))

  sample.shift
  sample.pop

  print "\r"
  sample.each do | power |
    print power.to_s.rjust(4)
  end
  sleep(song_length.to_f/1000)
end

print "\n"

sock.close
