# class SheepView < ActorView
  # def draw(target, x_off, y_off, z)
    # target.draw_box @actor.x,@actor.y, 20, 20, [240,45,45,255], 1
  # end
# end

class Sheep < Actor
  has_behavior :graphical

  def setup
  end

end
