PATH = '../../db/seeds/refdataA/cellmasks'
$data = []
$rows = 0
$cols = 0

def border?(x,y)
  c = $data[y][x]
  if c > 0
    x == 0 ||
    x == $cols - 1 ||
    y == 0 ||
    y == $rows - 1 ||
    $data[y][x-1] != c ||
    $data[y-1][x] != c ||
    $data[y][x+1] != c ||
    $data[y+1][x] != c
  end
end

puts "filename | \#cell coordinates (total) | \#border cells (total) | \#cells (total)"
count = 0
count_border = 0
count_cells = 0
time_start = Time.now
files = Dir.entries(PATH)
files = files.sort
files.each do |file|
  if File.file?(PATH + '/' + file)
    $data = []
    cells = Hash.new
    File.open(PATH + '/' + file) do |f|
      f.each do |line|
        $data << line.split(',').map(&:to_i)
      end
    end
    $rows = $data.length
    $cols = $data.first.length
    0.upto($rows-1) do |y|
      0.upto($cols-1) do |x|
        count += 1 if $data[y][x] > 0
        count_border += 1 if border?(x,y)
        if cells[$data[y][x]].nil?
          cells[$data[y][x]] = 1
          count_cells += 1
        end
      end
    end
    puts "#{file} #{count} #{count_border} #{count_cells}"
  end
end
puts (Time.now - time_start).to_s

# refdataA_209.txt 46.246.907 12.243.993 244.789
