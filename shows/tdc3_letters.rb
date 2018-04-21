#!/usr/bin/env ruby

letters = [
  ["E",9],
  ["A",7],
  ["N",6],
  ["R",6],
  ["D",5],
  ["L",5],
  ["O",5],
  ["S",5],
  ["T",5],
  ["B",4],
  ["I",4],
  ["K",4],
  ["F",3],
  ["G",3],
  ["M",3],
  ["U",3],
  ["V",3],
  ["H",2],
  ["J",2],
  ["P",2],
  ["Y",2],
  ["Æ",2],
  ["Ø",2],
  ["Å",2],
  ["C",2],
  ["X",1],
  ["Z",1],
  [" ",2]]

mix = Array.new

sets = 2

letters.each do | l |
  (l.last * sets).times do
    mix << l.first
  end
end
puts mix.length
#mix.shuffle!

require 'prawn'
require 'prawn/table'
Prawn::Document.generate("simple_table.pdf") do 

  table(mix.each_slice(14).to_a, :cell_style => {:padding => 12}) do
  end

end
