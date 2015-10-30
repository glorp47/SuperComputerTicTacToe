class PolyTreeNode
  attr_accessor :parent, :children, :value


  def initialize(value, parent = nil, children = [])
    @parent = parent
    @children = children
    @value = value
  end

  def parent
    @parent
  end

  def children
    @children
  end

  def value
    @value
  end

  def parent=(parent)
    @parent.children.delete(self) unless @parent.nil?
    @parent = parent
    @parent.children << self unless @parent.nil?
  end

  def add_child(child_node)
    child_node.parent = self
  end

  def remove_child(child_node)
    child_node.parent = nil
    raise "Sorry not a child node" if child_node.parent != self
  end

  def dfs(target_value)
    return self if @value == target_value
      @children.each do |child|
        result = child.dfs(target_value)
        return result unless result.nil?
      end
    nil
  end

  def bfs(target_value)
    local_queue = [self]
    until local_queue.empty?
      node = local_queue.shift
      return node if node.value == target_value
      node.children.each do |child|
        local_queue << child
      end
    end
    nil
  end

end
