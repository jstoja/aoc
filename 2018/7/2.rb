def get_tree(filename)
  data = {}
  re = 'Step\ (.)\ .*\ step\ (.)\ can\ begin'
  File.foreach(filename) do |line|
    matches = line.chomp.match(re).to_a
    parent = matches[1]
    children = matches[2]
    data[parent] = {parents: [], children: [], solved: false, started: -1} if data[parent].nil?
    data[children] = {parents: [], children: [], solved: false, started: -1} if data[children].nil?

    data[parent][:children] << children
    data[children][:parents] << parent
  end
  data
end

def time_by_letter(letter)
  letter.ord - 64 
end

def all_solved(tree, dep)
  dep.each do |d|
    if !tree[d].nil? && tree[d][:solved] == false
      return false
    end
  end
  return true
end

def avail_workers(aworkers)
  avail = []
  aworkers.each do |w, l|
    if l.empty?
      avail << w
    end
  end
  return avail
end

tree = get_tree('input.txt')
res = ''
workers = {}

second = 0
DELAY = 60
WORKERS = 5

# init workers
WORKERS.times do |worker|
  workers[worker] = ''
end

until tree.keys.empty? do
  deleted = false

  # check for finished work
  workers.each do |w, l|
    unless l.empty?
      if tree[l][:started] == 0
        res += l
        tree[l][:solved] = true
        workers[w] = ''
        tree.delete l
      end
    end
  end

  # Assign work
  tree.keys.sort.each do |k|
    if all_solved(tree, tree[k][:parents])
      w = avail_workers(workers).first
      if tree[k][:started] == -1 && !w.nil?
        tree[k][:started] = DELAY + time_by_letter(k)
        workers[w] = k
      end
    end
  end

  # Time pass by...
  workers.each do |w, l|
    unless tree[l].nil?
      tree[l][:started] -= 1
    end
  end

  puts "#{second}\t#{workers}\t#{res}"
  second += 1
end
