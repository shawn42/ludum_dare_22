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
    if @@images.nil?
      # TODO lift images for all types
      @@images = {
        genderless: {
          normal: resource_manager.load_image('sheep.png'),
          picked_up: resource_manager.load_image('sheep_lift.png'),
          dead: resource_manager.load_image('sheep_splat.png')
        },
        dude: {
          normal: resource_manager.load_image('dude_sheep.png'),
          picked_up: resource_manager.load_image('sheep_lift.png'),
        },
        chick: {
          normal: resource_manager.load_image('chick_sheep.png'),
          picked_up: resource_manager.load_image('sheep_lift.png'),
        },
      }
    end

    @gender = opts[:gender] || :dude
    @age = opts[:age] || 0
    update_image()
  end

  def bb
    Rect.new(self.x - 40, self.y - 30, width, height)
  end

  def collide_point?(x,y)
    bb.collide_point?(x,y)
  end

  def pickup!
    graphical.image = @picked_up_image
  end

  def release!
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
    # TODO boucy bouncy
    # TODO change to use a ttl and bind to removed event from @box
    @box = spawn :censor_box, box: bb
    self.mating = true
    other_sheep.mating = true
    
    add_timer 'mating', 2000 do
      self.mating = false
      other_sheep.mating = false
      @box.remove_self
      remove_timer 'mating'
      fire :did_the_hump
    end
  end

  def mating?
    !@mating.nil? and @mating
  end
  def mating=(mating)
    @mating = mating
  end


  def update(time)
    x_dir = rand(2) == 1 ? 1 : -1
    y_dir = rand(2) == 1 ? 1 : -1
    x_amount = x_dir * time / 100.0
    y_amount = y_dir * time / 100.0

    self.x += x_amount
    self.y += y_amount
  end

  def age!
    @age += 1
    update_image
    if (@age > 3)
      self.die!
    end
  end

  def die!
    graphical.image = @@images[:genderless][:dead]
    play_sound :sheep_death, volume: 0.25
    add_timer 'dying', 1000 do
      self.remove_self
    end
    @dead = true
  end

  def dead?
    !@dead.nil? and @dead
  end


  def update_image
    if @age == 0
      @idle_image = @@images[:genderless][:normal]
      @picked_up_image = @@images[:genderless][:picked_up]
      graphical.scale = 0.7 
    elsif @age == 1 or @age == 2
      @idle_image = @@images[gender][:normal]
      @picked_up_image = @@images[gender][:picked_up]
      graphical.scale = 1.0 
    else
      @idle_image = @@images[:genderless][:normal]
      @picked_up_image = @@images[:genderless][:picked_up]
      graphical.scale = 1.0 
    end
    graphical.image = @idle_image
  end
end

