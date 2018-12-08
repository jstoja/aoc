# 2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
# A----------------------------------
#     B----------- C-----------
#                      D-----
#
# * A, which has 2 child nodes (B, C) and 3 metadata entries (1, 1, 2).
# * B, which has 0 child nodes and 3 metadata entries (10, 11, 12).
# * C, which has 1 child node (D) and 1 metadata entry (2).
# * D, which has 0 child nodes and 1 metadata entry (99).

data = []
File.foreach('input.txt') do |line|
  data = line.split(' ').map(&:to_i)
end

def create_node(id, child_number, metadata_number, children, metadata)
  {id: id, child_number: child_number, metadata_number: metadata_number, children: children, metadata: metadata}
end

def count_offsets(node)
  o = 0
  unless node[:children].nil?
    node[:children].each do |c|
      o += 2
      o += count_offsets(c)
      o += c[:metadata_number]
    end
  end
  o
end

def create_tree(id, infos)
  return {} if infos[0].nil?
  children = []
  child_number = infos[0]
  metadata_number = infos[1]
  offset = 2
  curr_id = id.next
  child_number.times do
    new_children = create_tree(curr_id, infos[offset..(-1*metadata_number-1)])
    # offset by the header+children+meta
    offset += 2 + count_offsets(new_children) + new_children[:metadata_number]
    children << new_children
    curr_id = curr_id.next
  end
  # meta are the offset + meta size
  metadata = infos[offset..(offset+metadata_number-1)]
  create_node(id, child_number, metadata_number, children, metadata)
end

def sum_meta(tree)
  sum = 0
  sum += tree[:metadata].reduce(:+)
  tree[:children].each do |c|
    sum += sum_meta(c)
  end
  return sum
end

tree = create_tree('A', data)
pp sum_meta(tree)
