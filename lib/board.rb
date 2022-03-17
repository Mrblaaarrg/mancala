class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @cups = Array.new(14) { [] }
    self.place_stones
    @players = { name1 => 1, name2 => 2 }
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    @cups.each.with_index do |cup, i|
      4.times { cup << :stone } unless i == 6 || i == 13
    end
  end

  def valid_move?(start_pos)
    raise "Invalid starting cup" unless (0..12).include?(start_pos)
    raise "Starting cup is empty" if self.cups[start_pos].empty?
    true
  end

  def make_move(start_pos, current_player_name)
    queue, @cups[start_pos] = @cups[start_pos], []
    next_pos = start_pos
    until queue.empty?
      next_pos = (next_pos + 1) % 14
      next if next_pos == (@players[current_player_name] == 1 ? 13 : 6)
      @cups[next_pos] << queue.shift
    end

    self.render
    self.next_turn(next_pos)
  end

  def next_turn(ending_cup_idx)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
    return :prompt if [6, 13].include?(ending_cup_idx)
    return ending_cup_idx if @cups[ending_cup_idx].count > 1
    :switch
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    @cups[0..5].all?(&:empty?) || @cups[7..12].all?(&:empty?)
  end

  def winner
    return :draw if @cups[6].count == @cups[13].count
    if @cups[6].count > @cups[13].count
      return @players.keys[0]
    else
      return @players.keys[1]
    end
  end
end
