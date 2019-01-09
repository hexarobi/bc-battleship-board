#!/usr/bin/env ruby

BOARD_WIDTH = 10
BOARD_HEIGHT = 10

ORIENTATION_WEST = 0
ORIENTATION_SOUTH = 1
ORIENTATION_EAST = 2
ORIENTATION_NORTH = 3

POSITIONS_CHECK_LOOP_LIMIT = 1000

class BattleshipInitializer
  attr_accessor :board

  # Initialize an empty board with a . in each cell
  def initialize
    # The board is an array of rows, each containing an array of cells
    @board = Array.new(BOARD_HEIGHT){Array.new(BOARD_WIDTH)}
    @board.each_with_index do |y, yi|
      y.each_with_index do |x, xi|
        @board[yi][xi] = "."
      end
    end
  end

  # Print the current board contents
  def print_board
    if @board.nil?
      puts "Board not initialized"
    elsif @board.respond_to?("each")
      @board.each do |row|
        row.each do |cell|
          print "#{cell} "
        end
        puts "\n"
      end
    end
    puts "\n"
  end

  # Get a random cell position
  def get_random_position
    [rand(0..BOARD_WIDTH-1), rand(0..BOARD_HEIGHT-1)]
  end

  # Get a random ship orientation
  def get_random_orientation
    rand(0..3)
  end

  # Check if the position is a valid board position, and not already occupied
  def check_position(position)

    puts "Checking " + position[0].to_s + "," + position[1].to_s

    unless check_valid_board_position(position)
      puts "Invalid board position"
      return false
    end

    if @board[position[1]][position[0]] != "."
      puts "Position already occupied"
      false
    else
      true
    end

  end

  def check_valid_board_position(position)
    unless position.kind_of?(Array)
      puts "Invalid position"
      return false
    end
    if position[0] < 0
      puts "Underflow column"
      return false
    end
    if position[0] >= BOARD_WIDTH
      puts "Overflow column"
      return false
    end
    if position[1] < 0
      puts "Underflow row"
      return false
    end
    if position[1] >= BOARD_HEIGHT
      puts "Overflow row"
      return false
    end
    unless @board.kind_of?(Array)
      puts "Invalid board"
      return false
    end
    unless @board[position[1]].kind_of?(Array)
      puts "Invalid board row"
      return false
    end
    true
  end

  # Check that each position in a list of positions is valid
  def check_positions(positions)
    positions.each do |position|
      unless check_position(position)
        return false
      end
    end
    true
  end

  # Given the previous position and a directional orientation, generate the next position
  def get_next_position(last_position, orientation)
    case orientation
      when ORIENTATION_WEST
        [last_position[0],last_position[1]-1]
      when ORIENTATION_SOUTH
        [last_position[0]+1,last_position[1]]
      when ORIENTATION_EAST
        [last_position[0],last_position[1]+1]
      when ORIENTATION_NORTH
        [last_position[0]-1,last_position[1]]
      else
        puts "Invalid orientation"
    end
  end

  # Mark a set of positions with the marker character
  def mark_positions(positions, marker)
    positions.each do |position|
      @board[position[1]][position[0]] = marker
    end
  end

  # Given a fixed origin anchor point, an orientation direction, and a length
  # build an array of coordinates to represent the entire ship
  def extend_anchor(anchor, orientation, length)
    positions = [anchor]
    (length - 1).times do
      next_position = get_next_position(positions[-1], orientation)
      positions.push(next_position)
    end
    positions
  end

  def get_random_ship_location(length)
    anchor = get_random_position
    orientation = get_random_orientation
    extend_anchor(anchor, orientation, length)
  end

  # Add a ship to the board
  def add_ship(marker, length)

    ship_coordinates = []

    loop_counter = 0
    loop do

      ship_coordinates = get_random_ship_location(length)

      # Just in case of an infinite loop, break out once the loop limit has been reached
      loop_counter = loop_counter + 1
      if loop_counter > POSITIONS_CHECK_LOOP_LIMIT
        puts "Error: Positions check loop limit reached"
        return
      end

      # If the position isn't valid then try again
      break if check_positions(ship_coordinates)
        puts "Invalid position, trying again"
    end

    mark_positions(ship_coordinates, marker)

  end

end


if __FILE__ == $0
  bi = BattleshipInitializer.new
  bi.print_board

  bi.add_ship("T", 2)
  bi.print_board

  bi.add_ship("D", 3)
  bi.print_board

  bi.add_ship("S", 3)
  bi.print_board

  bi.add_ship("B", 4)
  bi.print_board

  bi.add_ship("C", 5)
  bi.print_board

end