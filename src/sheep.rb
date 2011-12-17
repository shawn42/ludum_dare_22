# class SheepView < ActorView
  # def draw(target, x_off, y_off, z)
    # target.draw_box @actor.x,@actor.y, 20, 20, [240,45,45,255], 1
  # end
# end

class Sheep < Actor
  has_behavior :graphical

  attr_accessor :picked_up

  def setup
    @h_width = width / 2
    @h_height = height / 2
    @picked_up_image = resource_manager.load_image 'sheep_lift.png'
  end

  def collide_point?(x,y)
    @bb = Rect.new(self.x - @h_width, self.y - @h_height, width, height)
    @bb.collide_point?(x,y)
  end

  def pickup!
    @picked_up = true
    @old_image = graphical.image
    graphical.image = @picked_up_image
  end

  def release!
    @picked_up = false
    graphical.image = @old_image
  end

end
