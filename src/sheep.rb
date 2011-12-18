class SheepView < GraphicalActorView
  def draw(target, x_off, y_off, z)
    # bb = actor.bb
    # target.draw_box bb.left, bb.top, bb.right, bb.bottom, Color::RED, 9999
    super
  end
end

class Sheep < Actor
  has_behavior :updatable, :audible, :graphical, :timed, :audible, layered: {layer: ZOrder::Sheep}

  @@images = nil
  attr_accessor :gender, :age

  def setup
    @clock = opts[:clock]
    if @@images.nil?
      @@images = {
        baby: {
          normal: resource_manager.load_image('baby_sheep.png'),
          picked_up: resource_manager.load_image('baby_sheep_lift.png'),
        },
        dude: {
          normal: resource_manager.load_image('dude_sheep.png'),
          picked_up: resource_manager.load_image('dude_sheep_lift.png'),
          dead: resource_manager.load_image('sheep_splat.png')
        },
        chick: {
          normal: resource_manager.load_image('chick_sheep.png'),
          picked_up: resource_manager.load_image('chick_sheep_lift.png'),
        },
        old: {
          normal: resource_manager.load_image('old_sheep.png'),
          picked_up: resource_manager.load_image('old_sheep_lift.png'),
        }
      }
    end

    if rand(3) == 0
      add_timer 'bah', 1000 + rand(3000) do
        play_sound :bah, speed: 1+rand-0.2
      end
    end

    @age = opts[:age] || 0
    @gender = opts[:gender] || :dude
    @health =
      if @age == 0
        1
      else
        case @gender
        when :dude
          4
        when :chick
          2
        end
      end

    update_image()
    @boundary = Rect.new(0, HORIZON, viewport.width, viewport.height - HORIZON)
  end

  def bb
    xs = self.x_scale.abs
    ys = self.y_scale.abs
    Rect.new(self.x - 40*xs, self.y - 30*ys, width*xs, height*ys)
  end

  def collide_point?(x,y)
    bb.collide_point?(x,y)
  end

  def pickup!
    @picked_up = true
    graphical.image = @picked_up_image
  end

  def release!
    @picked_up = false
    graphical.image = @idle_image
  end

  def mate(target_sheep)
    hump target_sheep
  end

  def can_mate?(sheep)
    sheep && 
      sheep != self && 
      sheep.gender && self.gender &&
      sheep.gender != self.gender &&
      sheep.age > 0 &&
      sheep.age < 3 &&
      self.age > 0 &&
      self.age < 3 &&
      !sheep.mating? &&
      !self.mating?
  end

  def hump(other_sheep)
    # TODO bouncy bouncy
    # TODO change to use a ttl and bind to removed event from @box
    @box = spawn :censor_box, box: bb
    self.mating = true
    other_sheep.mating = true
    mating_sounds
    add_timer 'mating', 2000 do
      finish_mating other_sheep
      @box.remove_self
      remove_timer 'mating'
      fire :did_the_hump
    end
  end

  def finish_mating(other_sheep)
    self.mating = false
    other_sheep.mating = false
    cold_distance = 100
    cold_x = cold_distance * (rand(2) == 0 ? 1 : -1)
    cold_y = cold_distance * (rand(2) == 0 ? 1 : -1)
    my_target = Ftor.new cold_x, cold_y

    shyness = 80 
    move_to self.x + my_target.x, self.y + my_target.y, shyness
    other_sheep.move_to self.x - my_target.x, self.y - my_target.y, shyness
  end

  def mating_sounds
    wavs = [:oooo, :ooh_la_la]
    pick = wavs[rand(wavs.size)]
    play_sound pick, speed: 1+rand-0.2
  end

  def mating?
    !@mating.nil? and @mating
  end
  def mating=(mating)
    @mating = mating
  end

  def update(time)
    move time unless mating? || dead?
  end

  def move_to(new_x, new_y, speed)
    if new_x > @boundary.right
      new_x = @boundary.right
    elsif new_x < 0
      new_x = 0
    end

    if new_y > @boundary.bottom
      new_y = @boundary.bottom
    elsif new_y < HORIZON
      new_y = HORIZON
    end

    @target = [new_x, new_y]
    @speed = speed
  end

  def random_target
    begin
      @target = [rand(1000), rand(800)]
    end while not @boundary.collide_point? @target[0], @target[1]
    @speed = rand(400) / 100.0
  end

  def move(time)
    movement_vector = nil
    unless @picked_up
      if @target.nil? or (@target[0] - self.x).abs < 2 or (@target[1] - self.y).abs < 2
        # No target, acquire one
        if @clock.daytime?
          random_target 
        else
          random_target
          # run_away_from_were_shepard
          # need to know where the wolfie is?
        end
      end

      full_vector = Ftor.new(@target[0] - self.x, @target[1] - self.y)
      if full_vector.magnitude.abs < @speed
        @speed = full_vector.magnitude
      end
      movement_vector = full_vector.unit * @speed * time / 100.0

      self.x += movement_vector[0]
      self.y += movement_vector[1]
      if self.y < HORIZON
        self.y = HORIZON
      end
    end

    size = (self.y / 600.0) + 0.3
    # haxors
    dir = graphical.x_scale < 0 ? -1 : 1
    graphical.x_scale = size * dir
    graphical.y_scale = size

    graphical.x_scale = (movement_vector.x > 0 ? -1 : 1) * graphical.x_scale.abs if movement_vector

  end

  def age!
    @age += 1
    @health = 
      case @gender
      when :dude
        4
      when :chick
        2
      end
    update_image
    if (@age > 3)
      self.die!
    end
  end

  def die!
    graphical.image = @@images[:dude][:dead]
    play_sound :sheep_death, volume: 0.25
    add_timer 'dying', 1000 do
      self.remove_self
    end
    @dead = true
  end

  def dead?
    !@dead.nil? and @dead
  end

  CRUNCH_SOUNDS = [:crunch1, :crunch2]
  def injure!
    @health -= 1
    spawn :gibs, size: (5-@health)*2, x: self.x, y: self.y
    play_sound CRUNCH_SOUNDS.sample
    die! if @health == 0

    case gender
    when :dude
      5
    when :chick
      4
    else #baby
      2
    end
  end

  def update_image
    if @age == 0
      @idle_image = @@images[:baby][:normal]
      @picked_up_image = @@images[:baby][:picked_up]
      graphical.scale = 0.6 
    elsif @age == 1 or @age == 2
      @idle_image = @@images[gender][:normal]
      @picked_up_image = @@images[gender][:picked_up]
      graphical.scale = 1.0 
    else # too old to breed
      @idle_image = @@images[:old][:normal]
      @picked_up_image = @@images[:old][:picked_up]
      graphical.scale = 0.9
    end
    graphical.image = @idle_image
  end
end

