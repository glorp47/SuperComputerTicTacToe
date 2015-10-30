require_relative 'tic_tac_toe_node'

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    intro_node = TicTacToeNode.new(game.board.rows, mark)
    children_array = intro_node.children
    move_that_doesnt_lose = []
    children_array.each do |child|
      return child.prev_move_pos if child.winning_node?(mark)
    end
    children_array.each do |child|
      return child.prev_move_pos if !child.losing_node?(mark)
    end
    raise "WHOA"
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Jeff")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end
