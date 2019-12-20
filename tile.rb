class Tile
  attr_accessor :value, :revealed

  def initialize
    @value = nil
    @revealed = false
    @flagged = false
  end

  def to_s
    return "F" if @flagged == true
    revealed ? @value.to_s : "*"
  end

  def inspect
    @value.to_s
  end

  def bomb?
    self.value == :B
  end

  def blank?
    self.value == "_"
  end

  def flagged
    @flagged
  end

  def revealed
    @flagged || @revealed
  end

  def correctly_flagged?
    # debugger if @flagged == true && @value == :B
    @flagged == (@value == :B)
  end

  def flag
    @flagged = @flagged ? false : true
  end

  def reveal
    @revealed = true
    @value
  end
  
end

