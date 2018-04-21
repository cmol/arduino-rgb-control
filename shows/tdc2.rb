#!/usr/bin/env ruby

require '/home/cmol/bin/lighter/lib/lighter'
require '/home/cmol/bin/mplayer-ruby/lib/mplayer-ruby'
require 'socket'
require 'thread'

# Creating controller
s = TCPSocket.new '10.7.10.35', 2000
@lc = Lighter::LampControl.new(socket: s)

# Defining music clips
@music = Hash.new
@music[:thunder1] = "/home/cmol/Music/tdc/thunder1.mp3"
@music[:avada] = "/home/cmol/Music/tdc/avada.mp3"
@music[:scream] = "/home/cmol/Music/tdc/scream.mp3"
@music[:laugh_belatrix] = "/home/cmol/Music/tdc/laugh-belatrix.mp3"
@music[:forest] = "/home/cmol/Music/forest.mp3"

# Mhm... colours
@color = [[0,120,70], [0,130,20], [120,0,30], [130, 70, 0], [0,20,12], [0,30,0], [20,0,30], [30, 7, 0]].cycle.each
@lamps = [0,1,2,3]


def blink(lamp)
  @lc.set(lamp, [255,255,128])
  sleep(0.05)
  @lc.fade(lamp,1, [0,0,0])
  sleep(0.1)
end

def blink2(lamp)
  @lc.fade(lamp,1, [255,255,128])
  sleep(0.1)
  @lc.fade(lamp,1, [0,0,0])
  sleep(0.2)
end

def breathe
  @lamps.each do | lamp |
    @lc.fade(lamp, 16, @color.next)
  end
end

def lightning
  player = MPlayer::Slave.new(@music[:thunder1])
  @lc.fade(4, 1, [0,0,0])
  sleep(0.2)
  blink(4)
  sleep(0.5)
  blink(0)
  sleep(0.2)
  blink(3)
  blink(2)
  sleep(0.8)
  blink(1)
  blink(3)
  blink(0)
  sleep(0.5)
  blink(0)
  sleep(0.3)
  blink(2)
  blink(0)
  sleep(0.2)
  blink(3)
  blink(2)
  sleep(0.8)
end

def avada
  player = MPlayer::Slave.new(@music[:avada])
  @lc.fade(4, 1, [0,0,0])
  sleep(1.95)
  @lc.set(4, [0,255,0])
  sleep(0.1)
  @lc.fade(4, 2, [0,50,0])
  sleep(0.2)
  @lc.fade(4, 1, [0,0,0])
  sleep(0.2)
  @lc.fade(4, 2, [0,50,0])
  sleep(0.2)
  @lc.fade(4, 1, [0,50,0])
  sleep(0.2)
  @lc.fade(4, 2, [0,0,0])
  sleep(0.2)
  @lc.fade(4, 1, [0,50,0])
  sleep(0.2)
  @lc.fade(4, 3, [0,25,0])
  sleep(1)
  @lc.fade(4, 3, [0,8,0])
  sleep(1)
end

def scream
  player = MPlayer::Slave.new(@music[:scream])
  @lc.fade(4, 2, [0,0,0])
  sleep(2.8)
  @lc.fade(4, 1, [255,0,0])
  sleep(0.2)
  @lc.fade(4, 15, [0,0,0])
  sleep(1.9)
end

def laugh_belatrix
  player = MPlayer::Slave.new(@music[:laugh_belatrix])
  @lc.fade(4, 20, [255,0,255])
  sleep(5)
  @lc.fade(4, 20, [64,0,64])
  sleep(2)
end

events = [method(:lightning), method(:avada), method(:scream), method(:laugh_belatrix)]

# Start light
@lc.fade(4,2, [0,255,0])

@run = true

Thread.new do
  server = TCPServer.new 2000
  client = server.accept
  client.gets
  client.close
  server.close
  @run = false
  puts "now!"
end

# Opening
while(@run) do
  breathe
  sleep(3)
  breathe
  sleep(3)
end

@lc.fade(4, 2, [0,0,0])
sleep(1)
@lc.close
`cd /home/cmol/bin/arduino-rgb-control ; ./moodtestTcp.rb /home/cmol/Music/tdc/horry-potter.mp3`

s = TCPSocket.new '10.7.10.35', 2000
@lc = Lighter::LampControl.new(socket: s)
@lc.fade(4, 25, [0,0,0])
sleep(5)

# Start playing horror music
drone_player = MPlayer::Slave.new(@music[:forest])
#drone_player.volume(:down)
#drone_player.volume(:down)

@run = true
Thread.new do
  puts "huh?"
  server = TCPServer.new 2000
  client = server.accept
  client.gets
  client.close
  @run = false
  puts "now!"
end


while(@run) do
  breathe
  sleep(3)
  breathe
  sleep(3)
  events.sample.call if rand(3) == 0
  #events.last.call
end

drone_player.quit
@lc.fade(4, 25, [0,0,0])
#sleep(5)
#@lc.close

#`cd /home/cmol/bin/arduino-rgb-control ; ./moodtestTcp.rb /home/cmol/Music/†/Justice\ -\ 06\ -\ Phantom\ Pt\ II.mp3`
#`cd /home/cmol/bin/arduino-rgb-control ; ./moodtestTcp.rb /media/lager/Mp3/Caravan\ Palace\ -\ Panic/09\ Dramophone.mp3`
#`cd /home/cmol/bin/arduino-rgb-control ; ./moodtestTcp.rb /home/cmol/Music/†/Justice\ -\ 03\ -\ D.A.N.C.E..mp3`

