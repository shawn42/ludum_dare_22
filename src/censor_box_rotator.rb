class CensorBoxRotator < Actor
  has_behavior :updatable
  def setup
    @range = -30..30
    @animation_time = 400
    setup_rot_tween
  end

  def setup_rot_tween
    if @rot_tween && @rot_tween[0] == @range.min
      @rot_tween = Tween.new @range.min, @range.max, Tween::Quad::InOut, @animation_time
    else
      @rot_tween = Tween.new @range.max, @range.min, Tween::Quad::InOut, @animation_time
    end
  end

  def rotation
    @rot_tween[0]
  end

  def update(time)
    setup_rot_tween if @rot_tween.done
    @rot_tween.update time
  end
end
