class Shadow < Actor
  has_behavior :updatable, :graphical, layered: {layer: ZOrder::Shadow}

  def setup
    @altitude = 0
  end

  def altitude=(value)
    @altitude = value
  end

  def move_to(new_x, new_y)
    self.x = new_x + (graphical.x_scale < 0 ? -1 : 1) * @offset[0]
    self.y = new_y + graphical.y_scale * @offset[1] + @altitude
  end
  def set_scale(x_scale, y_scale)
    graphical.x_scale = x_scale
    graphical.y_scale = y_scale
  end
end

class SheepShadow < Shadow
  def setup
    super
    @offset = [10, 32]
  end
end

class WolfShadow < Shadow
  def setup
    super
    @offset = [0, 50]
  end
end
