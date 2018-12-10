require 'set'
data = []

# position=< x,  y> velocity=< x,  y>
re = 'position=<\s*(\S+),\s*(\S+)>\ velocity=<\s*(\S+),\s*(\S+)>'

File.foreach('input.txt') do |line|
  matches = line.chomp.match(re).to_a[1..-1].map(&:to_i)
  data << matches
end

old_points = []
old_ysize = nil
points = data

i = 0
loop do
  points = points.map { |x, y, vx, vy| [x + vx, y + vy, vx, vy] }

  # find the Y size (when it's bigger there's a message)
  ymin, ymax = points.map { |x,y,vx,vy| y}.minmax
  ysize = ymax - ymin
  if !old_ysize.nil? && ysize > old_ysize
    ymin, ymax = old_points.map { |x,y,vx,vy| y}.minmax
    xmin, xmax = old_points.map { |x,y,vx,vy| x}.minmax
    (ymin..ymax).each do |yy|
      line = ''
      (xmin..xmax).each do |xx|
        if old_points.map{|x,y,vx,vy| [x,y]}.include?([xx, yy])
          line <<  '#'
        else
          line << '.'
        end
      end
      puts line
    end
    break
  end
  old_points = points
  old_ysize = ysize
  i += 1
end

puts i
