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

experiment = Experiment.create(:name => 'Test',
  :description => 'This experiment is used to test the db schema.')
  
images = Image.create([
  {:experiment => experiment, :filename => 'exp001/img001.jpg'},
  {:experiment => experiment, :filename => 'exp001/img002.jpg'},
  {:experiment => experiment, :filename => 'exp001/img003.jpg'}
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
  {:experiment => experiment, :image => images[0], :path => paths[0]},
  {:experiment => experiment, :image => images[0], :path => paths[1]},
  {:experiment => experiment, :image => images[0], :path => paths[4]},
  {:experiment => experiment, :image => images[1], :path => paths[0]},
  {:experiment => experiment, :image => images[1], :path => paths[2]},
  {:experiment => experiment, :image => images[1], :path => paths[3]},
  {:experiment => experiment, :image => images[1], :path => paths[4]},
  {:experiment => experiment, :image => images[2], :path => paths[0]},
  {:experiment => experiment, :image => images[2], :path => paths[2]},
  {:experiment => experiment, :image => images[2], :path => paths[3]},
  {:experiment => experiment, :image => images[2], :path => paths[5]},
  {:experiment => experiment, :image => images[2], :path => paths[6]}
])

Coordinate.create([
  {:experiment => experiment, :image => images[0], :cell => cells[0], :x => 0, :y => 0},
  {:experiment => experiment, :image => images[0], :cell => cells[0], :x => 0, :y => 1},
  {:experiment => experiment, :image => images[0], :cell => cells[0], :x => 1, :y => 0},
  {:experiment => experiment, :image => images[0], :cell => cells[0], :x => 1, :y => 1},
  {:experiment => experiment, :image => images[0], :cell => cells[1], :x => 3, :y => 3},
  {:experiment => experiment, :image => images[0], :cell => cells[1], :x => 4, :y => 3},
  {:experiment => experiment, :image => images[0], :cell => cells[1], :x => 3, :y => 4},
  {:experiment => experiment, :image => images[0], :cell => cells[1], :x => 4, :y => 4},
  {:experiment => experiment, :image => images[0], :cell => cells[2], :x => 4, :y => 0},
  {:experiment => experiment, :image => images[1], :cell => cells[3], :x => 0, :y => 0},
  {:experiment => experiment, :image => images[1], :cell => cells[3], :x => 0, :y => 1},
  {:experiment => experiment, :image => images[1], :cell => cells[4], :x => 0, :y => 3},
  {:experiment => experiment, :image => images[1], :cell => cells[4], :x => 0, :y => 4},
  {:experiment => experiment, :image => images[1], :cell => cells[5], :x => 2, :y => 3},
  {:experiment => experiment, :image => images[1], :cell => cells[5], :x => 2, :y => 4},
  {:experiment => experiment, :image => images[1], :cell => cells[6], :x => 3, :y => 0},
  {:experiment => experiment, :image => images[1], :cell => cells[6], :x => 3, :y => 1},
  {:experiment => experiment, :image => images[1], :cell => cells[6], :x => 4, :y => 0},
  {:experiment => experiment, :image => images[1], :cell => cells[6], :x => 4, :y => 1},
  {:experiment => experiment, :image => images[2], :cell => cells[7], :x => 0, :y => 0},
  {:experiment => experiment, :image => images[2], :cell => cells[7], :x => 0, :y => 1},
  {:experiment => experiment, :image => images[2], :cell => cells[7], :x => 1, :y => 1},
  {:experiment => experiment, :image => images[2], :cell => cells[8], :x => 0, :y => 3},
  {:experiment => experiment, :image => images[2], :cell => cells[8], :x => 0, :y => 4},
  {:experiment => experiment, :image => images[2], :cell => cells[9], :x => 2, :y => 3},
  {:experiment => experiment, :image => images[2], :cell => cells[9], :x => 2, :y => 4},
  {:experiment => experiment, :image => images[2], :cell => cells[10], :x => 2, :y => 0},
  {:experiment => experiment, :image => images[2], :cell => cells[10], :x => 2, :y => 1},
  {:experiment => experiment, :image => images[2], :cell => cells[11], :x => 4, :y => 0},
  {:experiment => experiment, :image => images[2], :cell => cells[11], :x => 4, :y => 1},
])
