class Tile
  attr_accessor :value, :revealed, :flagged

  def initialize
    @value = nil
    @revealed = false
    @flagged = false

  end

  def to_s
    revealed ? @value : "*"
  end

  def inspect
    @value.to_s
  end

    def bomb?
        self.value == :B
    end
end