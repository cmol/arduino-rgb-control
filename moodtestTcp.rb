#!/usr/bin/env ruby

require 'audioinfo'
require 'socket'
require '../mplayer-ruby/lib/mplayer-ruby'
require 'json'
require 'digest'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: moodtestTcp.rb [options] path to song(s)"

  opts.on("-q", "--quiet", "Run silently (no output)") do |v|
    options[:quiet] = true
  end
  opts.on("-s", "--sequential", "Run verbosely") do |v|
    options[:sequential] = true
  end

  opts.on("-d", "--dry", "Do a dry run without the connection") do |d|
    options[:dry] = d
  end

  opts.on("-n", "--disable-audio", "Run without playing music") do |n|
    options[:no_audio] = n
  end
end.parse!

if ARGV.empty?
  puts "Missing missing argument for song path"
  exit
end

config = JSON.parse(File.read('config.json'))
sock = TCPSocket.new config["address"], config["port"] unless options[:dry]

ARGV.each do | song_file |

  lamp = 3

  song_length=0
  song_info = 0
  md5 = ""
  AudioInfo.open(song_file) do |info|
    song_length = info.length   # playing time of the file
    song_info = [info.artist, info.title]

    # Create checksum of file data for optimization
    md5 = Digest::MD5.hexdigest "#{info.artist+info.album+info.length.to_s+info.title}"
  end

  # Generate the moodbar at location of the checksum
  path_to_mood = "/tmp/#{md5}.mood"
  unless File.exist?(path_to_mood) && File.size(path_to_mood) == 3000
    print "\033[2KGenerating moodbar.." unless options[:quiet]
    `moodbar -o #{path_to_mood} "#{song_file}"`
  end

  # Print pretty things
  print "\r\033[2K   R   G   B  - #{song_info[0]} - #{song_info[1]}             \n" unless options[:quiet]

  # Read the mood file
  samples = []
  s = File.binread(path_to_mood)
  bytes = s.unpack("C*")
  (1...1000).each do | sam |
    samples << [bytes[sam*3],bytes[sam*3+1],bytes[sam*3+2]].map{ |x| x==10 ? 11 : x }
  end

  # Fade length
  fade_length=song_length
  fade_length=fade_length*4 if options[:sequential]
  fade_length=(fade_length.to_f/10.0).ceil
  fade_length=1 if fade_length == 0
  puts fade_length

  # Start playing the file. It fast forwards to the real data before returning
  player = MPlayer::Slave.new(song_file) unless options[:no_audio]

  samples.each do | sample |
    if options[:sequential]
      lamp = (lamp == 3) ? 0 : lamp+1
    else
      lamp = 4
    end
    data = 0b00000010 | (lamp << 5)
    sample.insert(0, data)
    sample.insert(-1, fade_length & 0xff0000)
    sample.insert(-1, fade_length & 0x00ff00)
    sample.insert(-1, fade_length & 0x0000ff)
    sock.puts(sample.pack("CCCCCCC")) unless options[:dry]

    sample.shift
    sample.pop
    sample.pop
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

  player.quit if player

  print "\r\e[1A"
end

print "\e[1A\r\033[K2"

sock.close unless options[:dry]
