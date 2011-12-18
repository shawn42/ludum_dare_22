class GibsView < ActorView
  def draw(target, x_off, y_off, z)
    # TODO DO THIS!
    gibs = actor.gibs
    gibs.each do |gib|
      x = actor.x + gib[:x]
      y = actor.y + gib[:y]
      target.fill x, y, x+rand(5)+2, y+rand(5)+2, [200, 30, 10,190], z
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
    @gibs = []
    @size.times do
      @gibs << {x: 3, y: 5, size: 2, rot: Math::PI, dx: rand(4), dy: rand(5)-5, ttl: rand(1000)}
    end
    # add_timer 'ttl', 1000 do
    # end
  end

  def update(time)
    @gibs.each do |gib|
      gib[:x] += gib[:dx]
      gib[:y] += gib[:dy]
      gib[:dy] = gib[:dy] + 0.1
      gib[:ttl] -= time
    end

    remove_self unless @gibs.any?{|g|g[:ttl] > 0}
  end
end
