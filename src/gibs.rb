class GibsView < ActorView
  def draw(target, x_off, y_off, z)
    # TODO DO THIS!
    x = actor.x
    y = actor.y
    target.fill x, y, x+5, y+5, Color::RED, z
    return
    gibs = actor.gibs
    gibs.each do |gib|
      # actor.gib_image.draw_rot ....
    end
  end
end

class Gibs < Actor
  has_behavior layered: {layer: ZOrder::Gibs}
  has_behavior :updatable, :timed
  def setup
    @size = opts[:size]
    @gibs = [
      {x: 3, y: 5, size: 2, rot: Math::PI},
      {x: 3, y: 5, size: 2, rot: Math::PI},
      {x: 3, y: 5, size: 2, rot: Math::PI},
      {x: 3, y: 5, size: 2, rot: Math::PI},
    ]
    add_timer 'ttl', 1000 do
      remove_self
    end
  end

  def update(time)
    # modify all gibs
  end
end
