require_relative 'tic_tac_toe'
require 'byebug'

class Array
  def deep_dup
    map { |el| el.is_a?(Array) ? el.deep_dup : el }
  end
end

class TicTacToeNode
  attr_accessor :board, :next_mover_mark, :prev_move_pos
  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = Board.new(board)
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def children
      node_array = []
      @board.rows.each.with_index do |row, row_idx|
        row.each.with_index do |col, col_idx|
          pos = board.rows[row_idx][col_idx]
          if pos.nil?
            dup_board = board.rows.deep_dup
            prev_move_pos = [row_idx, col_idx]
            dup_board[row_idx][col_idx] = next_mover_mark
            node_array << TicTacToeNode.new(dup_board, switch_mark(next_mover_mark), prev_move_pos)
          end
        end
      end
      node_array
  end

  def switch_mark(mark)
    mark == :x ? :o : :x
  end

  def losing_node?(evaluator)
    if board.over?
      return false if board.winner == evaluator
      return true if board.winner == (nil || switch_mark(evaluator))
    elsif next_mover_mark == evaluator
      return true if children.all? {|child| child.losing_node?(evaluator)}
    else
      return true if children.any? {|child| child.losing_node?(evaluator)}
    end
    false
  end

  def winning_node?(evaluator)
    if board.over?
      return true if board.winner == evaluator
      return false if board.winner == (nil || switch_mark(evaluator))
    elsif next_mover_mark == evaluator
      return true if children.any? {|child| child.winning_node?(evaluator)}
    else
      return true if children.all? {|child| child.winning_node?(evaluator)}
    end
    false
  end




end

if __FILE__ == $PROGRAM_NAME
a = Array.new(3) {Array.new(3)}
a[0][0] = :o
a[0][2] = :o
b = TicTacToeNode.new(a, :o)
p b.board.rows
x = Board.new(a)
x.winner
p b.winning_node?(:o)
end
