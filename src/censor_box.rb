class CensorBoxView < ActorView
  def draw(target, x_off, y_off, z)
    bb = actor.bb
    target.fill x_off + bb.left, y_off + bb.top, bb.right, bb.bottom, Color::BLACK, z
  end
end

class CensorBox < Actor
  has_behavior :updatable, layered: {layer: ZOrder::HudBackground}
  attr_reader :bb
  def setup
#    @range = -30..30
#    @animation_time = 400
#    setup_rot_tween

    @bb = opts[:box]
    @bb.inflate! -10, -30
    @text = spawn :label, text: "CENSORED", font: FONT, size: 20, x: @bb.x+(@bb.width/2-45), y: @bb.y + (@bb.height/2-11), layer: ZOrder::HudText, color: Color::WHITE
    self.when :remove_me do
      @text.remove_self
    end
  end

  def setup_rot_tween
    if @rot_tween && @rot_tween[0] == @range.min
      @rot_tween = Tween.new @range.min, @range.max, Tween::Quad::InOut, @animation_time
    else
      @rot_tween = Tween.new @range.max, @range.min, Tween::Quad::InOut, @animation_time
    end
  end

  def update(time)
#    @rot_tween.update time
    x_dir = rand(2) == 1 ? 1 : -1
    y_dir = rand(2) == 1 ? 1 : -1
    x_amount = x_dir * time / 100.0
    y_amount = y_dir * time / 100.0

    @bb.x += x_amount
    @text.x += x_amount
    @bb.y += y_amount
    @text.y += y_amount
  end
end
