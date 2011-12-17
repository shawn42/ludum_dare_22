class WereShepard < Actor
  has_behavior :graphical, :updatable
  attr_accessor :move_left, :move_right, :move_up, :move_down

  def setup
    @clock = opts[:clock]
    @were = @clock.nighttime?

    @clock.when :transition_to_day do
      @were = false
    end

    @clock.when :transition_to_night do
      @were = true
    end

    i = input_manager
    i.while_pressed [KbW, KbUp], self, :move_up
    i.while_pressed [KbA, KbLeft], self, :move_left
    i.while_pressed [KbS, KbDown], self, :move_down
    i.while_pressed [KbD, KbRight], self, :move_right
  end

  def update(time)
    move time if @were
  end

  def move(time)
    horizontal_speed = 0.2
    vertical_speed = 0.1
    self.x += horizontal_speed * time if move_right
    self.x -= horizontal_speed * time if move_left
    self.y += vertical_speed * time if move_down
    self.y -= vertical_speed * time if move_up
  end

end
