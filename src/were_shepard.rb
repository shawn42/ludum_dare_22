class WereShepard < Actor
  has_behavior :audible, :graphical, :animated, :updatable, layered: {layer: ZOrder::Player}
  attr_accessor :move_left, :move_right, :move_up, :move_down

  HUNGER_SCALE = 1.3
  HORIZON = 240
  def setup
    @clock = opts[:clock]
    @hunger = 10
    @dir = 1
    @boundary = Rect.new(0, HORIZON, viewport.width, viewport.height - HORIZON)

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
    i.reg :down, KbSpace, MsLeft, do
      attack
    end
  end


  ATTACK_SOUNDS = [:swipe1, :swipe2, :swipe3, :swipe4]
  def attack
    if @were
      fire :attack, -@dir
      # eat(5)
      play_sound ATTACK_SOUNDS.sample
    end
  end

  def update(time)
    move time if @were

    size = (self.y / 600.0) + 0.3
    graphical.x_scale = size
    graphical.y_scale = size

    @dir = -1 if move_right
    @dir = 1 if move_left
    graphical.x_scale = @dir * graphical.x_scale.abs
  end

  def become_were_shepard
    @were = true
    self.action = :were_shepard
    @hunger *= HUNGER_SCALE
    puts "need #{@hunger}"
    @consumed_food = 0
    fire :require_food, @hunger
  end

  def eat(amount)
    puts "consumed #{amount}"
    @consumed_food += amount
    fire :ate_food, amount
  end

  def become_shepard
    die! if @consumed_food < @hunger
    @were = false
    self.action = :shepard
  end

  def die!
    puts "DIE"
    # remove_self
  end

  def move(time)
    horizontal_speed = 0.2
    vertical_speed = 0.1
    self.x += horizontal_speed * time if move_right
    self.x -= horizontal_speed * time if move_left
    self.y += vertical_speed * time if move_down
    self.y -= vertical_speed * time if move_up

    if self.y < HORIZON
      self.y = HORIZON
    end
  end

end
