#!/usr/bin/env ruby

require '/home/cmol/bin/lighter/lib/lighter'
require 'socket'

s = TCPSocket.new '10.7.10.35', 2000
@lc = Lighter::LampControl.new(socket: s)

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

c1 = [255,215,0]
c2 = [255,69,0]
c3 = [127,255,0]
c4 = [243,155,0]

tf = 20
ts = 3.5

loop do
  @lc.fade(0,tf, c1)
  @lc.fade(2,tf, c2)
  @lc.fade(1,tf, c3)
  @lc.fade(3,tf, c4)
  sleep(ts)
  @lc.fade(0,tf, c2)
  @lc.fade(2,tf, c3)
  @lc.fade(1,tf, c4)
  @lc.fade(3,tf, c1)
  sleep(ts)
  @lc.fade(0,tf, c3)
  @lc.fade(2,tf, c4)
  @lc.fade(1,tf, c1)
  @lc.fade(3,tf, c2)
  sleep(ts)
  @lc.fade(0,tf, c4)
  @lc.fade(2,tf, c1)
  @lc.fade(1,tf, c2)
  @lc.fade(3,tf, c3)
  sleep(ts)
end

