class WereShepherd < Actor
  has_behavior :audible, :graphical, :animated, :updatable, layered: {layer: ZOrder::PeopleInTheField}
  attr_accessor :move_left, :move_right, :move_up, :move_down

  HUNGER_SCALE = 1.3
  def setup
    @clock = opts[:clock]
    @hunger = 10
    @consumed_food = 0
    @dir = 1
    @boundary = Rect.new(0, HORIZON, viewport.width, viewport.height - HORIZON)
    @blink_timer = 0
    @blink_interval = 2000

    @clock.nighttime? ? become_were_shepherd : become_shepherd

    @clock.when :transition_to_day do
      stage.remove_timer 'endswipe'
      become_shepherd
    end
    @clock.when :transition_to_night do
      become_were_shepherd
    end

    i = input_manager
    i.while_pressed [KbW, KbUp], self, :move_up
    i.while_pressed [KbA, KbLeft], self, :move_left
    i.while_pressed [KbS, KbDown], self, :move_down
    i.while_pressed [KbD, KbRight], self, :move_right
    i.reg :down, KbSpace, MsLeft do
      attack
    end
  end


  ATTACK_SOUNDS = [:swipe1, :swipe2, :swipe3, :swipe4]
  def attack
    if @were
      fire :attack, -@dir
      # eat(5)
      play_sound ATTACK_SOUNDS.sample
      self.action = :swipe
      stage.add_timer 'endswipe', 200 do
        self.action = :were_shepherd
        stage.remove_timer 'endswipe'
      end
    end
  end

  def update(time)
    if @were
      move time 

      size = (self.y / 600.0) + 0.3
      graphical.x_scale = size
      graphical.y_scale = size

      @dir = -1 if move_right
      @dir = 1 if move_left
      graphical.x_scale = @dir * graphical.x_scale.abs
      @my_shadow.set_scale(graphical.x_scale, graphical.y_scale)
      @my_shadow.move_to(self.x, self.y)
    else
      @blink_timer += time
      if @blink_timer > @blink_interval
        @blink_timer = 0
        @blink_interval = rand(50) * 100 + 500
        self.action = :blink
        stage.add_timer 'endblink', 200 do
          self.action = :shepherd
          stage.remove_timer 'endblink'
        end
      end
    end
  end

  def become_were_shepherd
    @were = true
    self.action = :were_shepherd
    fire :require_food, @hunger
    @my_shadow = spawn :were_shepherd_shadow

    # Just to be sure we don't get odd flickering
    stage.remove_timer 'endblink'
  end

  def eat(amount)
    @consumed_food += amount
    fire :ate_food, amount
  end

  def become_shepherd(started = true)
    die! if @consumed_food < @hunger && @clock.started?
    @consumed_food = 0
    @hunger *= HUNGER_SCALE
    @were = false
    self.action = :shepherd
    if !@my_shadow.nil?
      @my_shadow.remove_self
      @my_shadow = nil
    end
  end

  def die!
    self.remove_self
  end

  def move(time)
    horizontal_speed = 0.2
    vertical_speed = 0.13
    self.x += horizontal_speed * time if move_right
    self.x -= horizontal_speed * time if move_left
    self.y += vertical_speed * time if move_down
    self.y -= vertical_speed * time if move_up

    self.y = viewport.height - 1 if y > viewport.height
    self.x = 1 if x < 0    
    self.x = viewport.width - 1 if x > viewport.width

    if self.y < HORIZON
      self.y = HORIZON
    end
  end

end
