def get_tree(filename)
  data = {}
  re = 'Step\ (.)\ .*\ step\ (.)\ can\ begin'
  File.foreach(filename) do |line|
    matches = line.chomp.match(re).to_a
    parent = matches[1]
    children = matches[2]
    data[parent] = {parents: [], children: [], solved: false} if data[parent].nil?
    data[children] = {parents: [], children: [], solved: false} if data[children].nil?

    data[parent][:children] << children
    data[children][:parents] << parent
  end
  data
end

def all_solved(tree, dep)
  dep.each do |d|
    if !tree[d].nil? && tree[d][:solved] == false
      return false
    end
  end
  return true
end

tree = get_tree('input.txt')
res = ''

loop do
  tree.keys.sort.each do |k|
    if tree[k][:children].empty? && (tree.keys.size == 1)
      puts res+k
      exit
    end

    if all_solved(tree, tree[k][:parents])
      res += k
      puts "deleting #{k} #{tree[k][:parents]}"
      tree[k][:solved] = true
      tree.delete k
      break
    end
  end
end
