class CensorBoxView < ActorView
  def draw(target, x_off, y_off, z)
    bb = actor.bb
    target.fill x_off + bb.left, y_off + bb.top, bb.right, bb.bottom, Color::BLACK, z
  end
end

class CensorBox < Actor
  has_behavior :updatable, layered: {layer: 999}
  attr_reader :bb
  def setup
    @bb = opts[:box]
    @bb.inflate! -10, -30
  end

  def update(time)
    x_dir = rand(2) == 1 ? 1 : -1
    y_dir = rand(2) == 1 ? 1 : -1
    x_amount = x_dir * time / 100.0
    y_amount = y_dir * time / 100.0

    @bb.x += x_amount
    @bb.y += y_amount
  end
end
