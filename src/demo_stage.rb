class DemoStage < Stage
  BGCOLOR = [60,60,60]
  def setup
    super
    @sheep = spawn :sheep, x: 100, y: 100
    @clock = spawn :clock, x: 850, y: 10
    @sun = spawn :sun, x: 0, y: 200, clock: @clock, offset: (Math::PI/2.0)
    @moon = spawn :moon, x: 0, y: 200, clock: @clock, offset: -1 * (Math::PI/2.0)

    @clock.when :transition_to_day do
      puts "Daytime"
    end
    @clock.when :transition_to_night do
      puts "Night time"
    end
  end

  def draw(target)
    target.fill_screen BGCOLOR, 0
    super
  end
end

class HeavenlyBody < Actor
  has_behavior :updatable, :graphical

  def setup
    @clock = opts[:clock]
    @center = [600, 100]
    @radius = 50
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

class Sun < HeavenlyBody
end
class Moon < HeavenlyBody
end
