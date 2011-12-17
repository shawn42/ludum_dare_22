class SheepView < GraphicalActorView
  def draw(target, x_off, y_off, z)
    bb = actor.bb
    target.draw_box bb.left, bb.top, bb.right, bb.bottom, Color::RED, 9999
    super
  end
end

class Sheep < Actor
  has_behavior :updatable, :graphical, :timed, :audible, layered: {layer: ZOrder::Sheep}

  def setup
    # TODO lift images for all types
    @picked_up_image = resource_manager.load_image 'sheep_lift.png'
    @idle_image = graphical.image
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
    hump
  end

  def can_mate?(sheep)
    sheep && 
      sheep != self && 
      sheep.gender && self.gender &&
      sheep.gender != self.gender
  end

  def hump
    # TODO boucy bouncy
    # TODO change to use a ttl and bind to removed event from @box
    @box = spawn :censor_box, box: bb
    add_timer 'mating', 2000 do
      @box.remove_self
      remove_timer 'mating'
      fire :did_the_hump
    end
  end

  def gender
    nil
  end

  def update(time)
    x_dir = rand(2) == 1 ? 1 : -1
    y_dir = rand(2) == 1 ? 1 : -1
    x_amount = x_dir * time / 100.0
    y_amount = y_dir * time / 100.0

    self.x += x_amount
    self.y += y_amount
  end

end

class BabySheep < Sheep
  def setup
    super
    graphical.scale = 0.7
  end
end

class DudeSheep < Sheep
  def gender
    :dude
  end
  def pickup!
    super
    play_sound :dude_pickup
  end
end
class ChickSheep < Sheep
  def gender
    :chick
  end

  def pickup!
    super
    play_sound :chick_pickup
  end
end
