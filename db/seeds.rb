# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# images[0]  images[1]  images[2]
# 00..2      3..66      7.A.B
# 00...      3..66      77A.B
# ..11.      .....      .....
# ..11.      4.5..      8.9..
# .....      4.5..      8.9..
#
# paths[0]: cells(0,3,7)
# paths[1]: cells[1]
# paths[2]: cells(4,8)
# paths[3]: cells(5,9)
# paths[4]: cells(2,6)
# paths[5]: cells[10]
# paths[6]: cells[11]
# 
# trees[0]: paths[0]
# trees[1]: paths(1,2,3)  1 child {2,3}
# tress[2]: paths(4,5,6)  4 child {5,6}

experiment = Experiment.new(:name => 'Test',
  :description => 'This experiment is used to test the db schema.')
# assume experiment import is ready
experiment.import_progress = ''
experiment.import_done = true
experiment.save!
  
images = Image.create([
  {:experiment => experiment, :ord => 1},
  {:experiment => experiment, :ord => 2},
  {:experiment => experiment, :ord => 3}
])

Picture.create([
  {:experiment => experiment, :image => images[0],
    :filename => 'refdataA-contrast_1/refdataA_C1_001.png'},
  {:experiment => experiment, :image => images[1],
    :filename => 'refdataA-contrast_1/refdataA_C1_002.png'},
  {:experiment => experiment, :image => images[2],
    :filename => 'refdataA-contrast_1/refdataA_C1_003.png'}
])

trees = Tree.create([
  {:experiment => experiment},
  {:experiment => experiment},
  {:experiment => experiment}
])

paths = Path.create([
  {:experiment => experiment, :tree => trees[0]},
  {:experiment => experiment, :tree => trees[1]},
  {:experiment => experiment, :tree => trees[1]},
  {:experiment => experiment, :tree => trees[1]},
  {:experiment => experiment, :tree => trees[2]},
  {:experiment => experiment, :tree => trees[2]},
  {:experiment => experiment, :tree => trees[2]}
])

paths[1].succ_paths = [paths[2], paths[3]]
paths[4].succ_paths = [paths[5], paths[6]]
paths.each{|p| p.save!}

trees[0].root_path = paths[0];
trees[1].root_path = paths[1];
trees[2].root_path = paths[4];
trees.each{|t| t.save!}

cells = Cell.create([
  {:experiment => experiment, :image => images[0], :path => paths[0], :top => 0,
    :left => 0, :center_x => 0, :center_y => 0, :width => 2, :height => 2,
    :mask => [0b11110000].pack('C*')},
  {:experiment => experiment, :image => images[0], :path => paths[1], :top => 2,
    :left => 2, :center_x => 2, :center_y => 2, :width => 2, :height => 2,
    :mask => [0b11110000].pack('C*')},
  {:experiment => experiment, :image => images[0], :path => paths[4], :top => 0,
    :left => 4, :center_x => 4, :center_y => 0, :width => 1, :height => 1,
    :mask => [0b10000000].pack('C*')},
  {:experiment => experiment, :image => images[1], :path => paths[0], :top => 0,
    :left => 0, :center_x => 0, :center_y => 0, :width => 1, :height => 2,
    :mask => [0b11000000].pack('C*')},
  {:experiment => experiment, :image => images[1], :path => paths[2], :top => 3,
    :left => 0, :center_x => 0, :center_y => 3, :width => 1, :height => 2,
    :mask => [0b11000000].pack('C*')},
  {:experiment => experiment, :image => images[1], :path => paths[3], :top => 3,
    :left => 2, :center_x => 2, :center_y => 3, :width => 1, :height => 2,
    :mask => [0b11000000].pack('C*')},
  {:experiment => experiment, :image => images[1], :path => paths[4], :top => 0,
    :left => 3, :center_x => 3, :center_y => 0, :width => 2, :height => 2,
    :mask => [0b11110000].pack('C*')},
  {:experiment => experiment, :image => images[2], :path => paths[0], :top => 0,
    :left => 0, :center_x => 0, :center_y => 0, :width => 2, :height => 2,
    :mask => [0b10110000].pack('C*')},
  {:experiment => experiment, :image => images[2], :path => paths[2], :top => 3,
    :left => 0, :center_x => 3, :center_y => 0, :width => 1, :height => 2,
    :mask => [0b11000000].pack('C*')},
  {:experiment => experiment, :image => images[2], :path => paths[3], :top => 3,
    :left => 2, :center_x => 2, :center_y => 3, :width => 1, :height => 2,
    :mask => [0b11000000].pack('C*')},
  {:experiment => experiment, :image => images[2], :path => paths[5], :top => 0,
    :left => 2, :center_x => 2, :center_y => 0, :width => 1, :height => 2,
    :mask => [0b11000000].pack('C*')},
  {:experiment => experiment, :image => images[2], :path => paths[6], :top => 0,
    :left => 4, :center_x => 4, :center_y => 0, :width => 1, :height => 2,
    :mask => [0b11000000].pack('C*')}
])
