class WereShepard < Actor
  has_behavior :graphical, :animated, :updatable, layered: {layer: ZOrder::Player}
  attr_accessor :move_left, :move_right, :move_up, :move_down

  def setup
    @clock = opts[:clock]
    @clock.nighttime? ? become_were_shepard : become_shepard

    @clock.when :transition_to_day do
      become_shepard
    end

    @clock.when :transition_to_night do
      become_were_shepard
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

  def become_were_shepard
    @were = true
    self.action = :were_shepard
  end

  def become_shepard
    @were = false
    self.action = :shepard
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
