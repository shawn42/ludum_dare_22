class HeavenlyBody < Actor
  has_behavior :updatable, :graphical, layered: {layer: ZOrder::HeavenlyBody}

  def setup
    @clock = opts[:clock]
    @center = [600, 200]
    @radius = 150
    @offset = opts[:offset]
    # @center = [wrapped_screen.width/2, wrapped_screen.height]
    # @radius = wrapped_screen.height
  end

  def update(time)
    rads = 2 * Math::PI * @clock.percent_of_day + @offset
    ex = @radius * Math.cos(rads)
    ey = @radius * Math.sin(rads)
    self.x = ex+@center[0]
    self.y = ey+@center[1]   
  end

  def deg_to_rads(deg)
    deg * Math::PI / 180.0
  end
  
  def rads_to_degs(rads)
    rads * 180.0 / Math::PI
  end  
end


