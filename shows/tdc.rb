#!/usr/bin/env ruby

require '/home/cmol/bin/lighter/lib/lighter'
require '/home/cmol/bin/mplayer-ruby/lib/mplayer-ruby'
require 'socket'

s = TCPSocket.new '10.7.10.35', 2000
@lc = Lighter::LampControl.new(socket: s)
start_seq = "/tank/storage/music/tdc/tdc-proj.mp3"
space_music = "/tank/storage/music/tdc/space.mp3"

def blink(lamp)
  @lc.fade(lamp,1, [255,255,128])
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
# Start light
@lc.fade(4,2, [0,255,0])

# Some sort of trigger
#server = TCPServer.new 2000
#client = server.accept
#client.gets
@lc.fade(4,1,[0,0,0])
#client.close
sleep(0.5)

# Countdown
player = MPlayer::Slave.new(start_seq)

10.times do
  @lc.fade(4,3, [120,120,0])
  sleep(0.5)
  @lc.fade(4,3, [0,0,0])
  sleep(0.52)
end

blink(0)
sleep(0.2)
blink(3)
blink(2)
sleep(0.8)
blink(1)
blink(3)
blink(0)
sleep(0.5)
blink(4)
sleep(0.7)
blink(0)
sleep(0.3)
blink(2)
blink(3)
sleep(0.3)
blink(0)
sleep(0.2)
blink(3)
blink(2)
sleep(0.8)
blink(1)
blink(3)
blink(0)
sleep(0.5)
blink(4)
sleep(0.2)
blink(0)
sleep(0.3)
blink(2)
blink(0)
sleep(0.2)
blink(3)
blink(2)
sleep(0.8)
blink(1)
blink(3)
blink(0)
sleep(0.5)
blink(4)
sleep(0.7)
blink(0)
sleep(0.3)
blink(2)
blink(3)
sleep(0.3)
blink(0)
sleep(0.2)
blink(3)
blink(2)
sleep(0.8)
blink(1)
blink(3)
blink(0)
sleep(0.5)
blink(4)
sleep(0.2)
blink(0)
sleep(0.3)
blink(2)
sleep(0.5)
blink(4)
sleep(0.7)
blink(0)
sleep(0.3)
blink(2)
blink(3)
sleep(0.3)
blink(0)
sleep(0.2)
blink(3)


7.times do
  @lc.fade(4, 8, [255,0,0])
  sleep(1.2)
  @lc.fade(4, 2, [0,0,0])
  sleep(0.3)
end

@lc.fade(4, 8, [255,0,0])
sleep(1.2)
@lc.fade(4, 0, [0,0,0])
sleep(8)


player = MPlayer::Slave.new(space_music)
loop do
  @lc.fade(4, 8, [255,0,0])
  sleep(1.2)
  @lc.fade(4, 2, [0,0,0])
  sleep(0.3)
end
