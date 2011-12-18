class GibsView < ActorView
  def draw(target, x_off, y_off, z)
    # TODO DO THIS!
    gibs = actor.gibs
    gibs.each do |gib|
      x = actor.x + gib[:x]
      y = actor.y + gib[:y]
      target.fill x, y, x+2, y+2, Color::RED, z
      # actor.gib_image.draw_rot ....
    end
  end
end

class Gibs < Actor
  has_behavior layered: {layer: ZOrder::Gibs}
  has_behavior :updatable, :timed
  attr_accessor :gibs
  
  def setup
    @size = opts[:size]
    @gibs = [
    {x: 3, y: 5, size: 2, rot: Math::PI, dx: rand(4)},
      {x: 3, y: 5, size: 2, rot: Math::PI, dx: rand(4)},
      {x: 3, y: 5, size: 2, rot: Math::PI, dx: rand(4)},
      {x: 3, y: 5, size: 2, rot: Math::PI, dx: rand(4)},
    ]
    add_timer 'ttl', 1000 do
      remove_self
    end
  end

  def update(time)
    @gibs.each do |gib|
      gib[:x] += gib[:dx]
    end
  end
end
