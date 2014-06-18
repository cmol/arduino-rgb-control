#!/usr/bin/env ruby

require 'audioinfo'
require 'socket'
require '../mplayer-ruby/lib/mplayer-ruby'
require 'json'
require 'digest'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: moodtestTcp.rb -p [path_to_song] [options]"

  opts.on("-q", "--quiet", "Run silently (no output)") do |v|
    options[:quiet] = true
  end
  opts.on("-s", "--sequential", "Run verbosely") do |v|
    options[:sequential] = true
  end

  opts.on("-p", "--path", "Path to file") do |p|
    options[:path] = p
  end

  opts.on("-d", "--dry", "Do a dry run without the connection") do |d|
    options[:dry] = d
  end
end.parse!

if options[:path].nil?
  puts "Missing argument -p path_to_song. Exiting..."
  exit
end

config = JSON.parse(File.read('config.json'))
sock = TCPSocket.new config["address"], config["port"] unless options[:dry]

song_file = ARGV[0]

lamp = 3

song_length=0
md5 = ""
AudioInfo.open(song_file) do |info|
  song_length = info.length   # playing time of the file

  # Create checksum of file data for optimization
  md5 = Digest::MD5.hexdigest "#{info.artist+info.album+info.length.to_s+info.title}"
end

# Generate the moodbar at location of the checksum
path_to_mood = "/tmp/#{md5}.mood"
unless File.exist?(path_to_mood) && File.size(path_to_mood) == 3000
  print "Generating moodbar.." unless options[:quiet]
  `moodbar -o #{path_to_mood} "#{song_file}"`
end

# Print pretty things
print "\r   R   G   B        \n" unless options[:quiet]

# Read the mood file
samples = []
s = File.binread(path_to_mood)
bytes = s.unpack("C*")
(1...1000).each do | sam |
  samples << [bytes[sam*3],bytes[sam*3+1],bytes[sam*3+2]].map{ |x| x==10 ? 11 : x }
end

# Start playing the file. It fast forwards to the real data before returning
player = MPlayer::Slave.new(song_file)

samples.each do | sample |
  if options[:sequential]
    lamp = (lamp == 3) ? 0 : lamp+1
  else
    lamp = 4
  end
  data = 0b00000001 | (lamp << 5)
  sample.insert(0, data)
  sample.insert(-1, 1)
  sock.puts(sample.pack("CCCCC")) unless options[:dry]

  sample.shift
  sample.pop

  unless options[:quiet]
    print "\r"
    sample.each do | power |
      print power.to_s.rjust(4)
    end
  end

  # Sleep for a 1000th of the song time.
  # TODO: Make some timing instead, should be easy
  sleep(song_length.to_f/1000)
end

print "\n"

player.quit
sock.close unless options[:dry]
