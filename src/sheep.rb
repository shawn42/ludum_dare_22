class SheepView < GraphicalActorView
  def draw(target, x_off, y_off, z)
    super
    # bb = actor.bb
    # target.draw_box bb.left, bb.top, bb.right, bb.bottom, Color::RED, 9999
  end
end

class Sheep < Actor
  has_behavior :graphical, :timed

  def setup
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
    @box = spawn :censor_box, box: bb
    add_timer 'mating', 2000 do
      @box.remove_self
    end

    hump

    puts "#{self.object_id} mated with #{target_sheep.object_id}"
  end

  def can_mate?(sheep)
    if sheep && (sheep != self)
      true # for now; love for all
    end
  end

  def hump
    # TODO boucy bouncy
  end

end
