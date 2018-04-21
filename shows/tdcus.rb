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
@music[:forest] = "/home/cmol/Music/tdc/forest.mp3"
@music[:child_laugh] = "/home/cmol/Music/tdc/child1-edit.mp3"
@music[:amusement] = "/home/cmol/Music/tdc/amusement.mp3"
@music[:scream] = "/home/cmol/Music/tdc/scream2.mp3"
@music[:song] = "/home/cmol/Music/tdc/kid_song.mp3"

# Mhm... colours
@color = [[0,20,150], [20,11,130], [30,0,180], [11, 20, 190], [50,50,100], [11,11,190], [0,0,30], [0, 7, 70]].cycle.each
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
    @lc.fade(lamp, 30, @color.next)
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

def laugh1
  player = MPlayer::Slave.new(@music[:child_laugh])
  @lc.fade(4,1,[0,0,0])
  sleep(0.2)
  @lc.fade(0,2,[255,0,0])
  @lc.fade(3,2,[0,0,255])
  sleep(2.5)
  @lc.fade(4,1,[0,0,0])
  @lc.fade(1,2,[0,0,255])
  @lc.fade(2,2,[255,0,0])
  sleep(2)
  @lc.fade(4,1,[0,0,0])
  blink(0)
  sleep(0.12)
  blink(1)
  sleep(0.12)
  blink(2)
  sleep(0.12)
  blink(3)
  sleep(0.12)
  blink(0)
  sleep(0.12)
  blink(1)
  sleep(0.12)
  blink(2)
  sleep(0.12)
  blink(3)
  sleep(0.12)
  blink(0)
  sleep(0.12)
end

def amuse
  player = MPlayer::Slave.new(@music[:amusement])
  @lc.fade(4,1,[0,0,0])
  sleep(0.2)
  @lc.fade(0,2,[255,0,0])
  cols = [
    [255,0,0],
    [0,255,0],
    [0,0,255],
    [255,0,255],
    [255,255,0],
    [0,255,255],
    [128,255,128]]

  4.times do
    @lamps.each do |l|
      @lc.fade(l,3,cols.sample)
      sleep(0.35)
      @lc.fade(l,1,[0,0,0])
    end
  end


  @lc.fade(0,3,cols.sample)
  sleep(0.35)
  @lc.fade(0,1,[0,0,0])
  @lc.fade(1,3,cols.sample)
  sleep(0.35)
  @lc.fade(1,1,[0,0,0])

  sleep(0.1)
  @lc.fade(4,1,[255,0,0])
  sleep(0.2)
  @lc.fade(4,2,[0,0,0])
  sleep(3)
end

def scream
  @lc.fade(4,1,[0,0,0])
  player = MPlayer::Slave.new(@music[:scream])
  @lc.fade(0,1,[128,128,0])
  @lc.fade(3,1,[128,128,0])
  sleep(0.2)
  @lc.fade(4,1,[0,0,0])
  @lc.fade(2,1,[255,128,255])
  @lc.fade(1,1,[255,128,255])
  sleep(0.5)
  @lc.fade(4,1,[0,0,0])
  sleep(1.5)
end

def song
  player = MPlayer::Slave.new(@music[:song])
  3.times do
    breathe
    sleep(3.02)
  end
  blink(4)
  sleep(2)
end

events = [method(:lightning), method(:laugh1), method(:amuse),method(:scream), method(:song)]

# Start light
@lc.fade(4,2, [0,0,255])

# Start playing horror music
drone_player = MPlayer::Slave.new(@music[:forest])
#drone_player.volume(:down)
#drone_player.volume(:down)

while true do
  breathe
  sleep(3.02)
  breathe
  sleep(3.02)
  events.sample.call if rand(3) == 0
  #events.last.call
end
