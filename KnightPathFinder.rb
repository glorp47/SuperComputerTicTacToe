require_relative '00_tree_node'
require 'byebug'

class Array
  def valid_moves
    deltas = [1,-1,2,-2].permutation(2).to_a.select{|x,y| x.abs!=y.abs}
    result = []
    deltas.each do |delta|
      result << [self[0]+delta[0], self[1]+delta[1]]
    end
    result.select{|x,y| x.between?(0,8) && y.between?(0,8)}
  end
end


class KnightPathFinder
  attr_accessor :start_pos, :visited_positions

  def initialize(pos=[0,0])
    @start_pos = pos
    @visited_positions = [pos]
  end

  def build_move_tree
    root = PolyTreeNode.new(start_pos)
    queue = [root]
    until queue.empty?
      current_node = queue.shift
      node_positions = new_move_positions(current_node.value)
      node_positions.each do |pos|
        new_node = PolyTreeNode.new(pos)
        current_node.add_child(new_node)
        queue.push(new_node)
      end
    end
    root
  end

  def find_path(end_pos)
    target_node = build_move_tree.bfs(end_pos)
    trace_path_back(target_node)
  end

  def trace_path_back(target_node)
    path = [target_node]
    node = target_node
    until node.parent.nil?
      path << node.parent
      node = node.parent
    end
    path.map(&:value).reverse
  end

  def new_move_positions(pos)
    new_moves = pos.valid_moves.reject{|x| visited_positions.include?(x)}
    @visited_positions += new_moves
    new_moves
  end

end

if __FILE__==$PROGRAM_NAME
  kpf = KnightPathFinder.new([0,0])
  # p [0,0].valid_moves
  # p kpf.visited_positions
  p kpf.find_path([6, 2])
end
