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

    input_manager.reg :mouse_down, MsLeft do |event|
      check_for_sheep_under_mouse event[:data]
    end
    input_manager.reg :mouse_up, MsLeft do |event|
      release_sheep event[:data]
    end
    input_manager.reg :mouse_motion do |event|
      move_sheep event[:data]
    end
  end

  def draw(target)
    target.fill_screen BGCOLOR, 0
    super
  end

  def check_for_sheep_under_mouse(event_data)
    if @sheep.collide_point?(*event_data)
      @sheep_under_mouse = @sheep 
      @sheep_under_mouse.pickup!
      puts "Got sheep under cursor"
    end
  end

  def move_sheep(event_data)
    # TODO capture click offset from sheep x,y
    if @sheep_under_mouse
      @sheep_under_mouse.x = event_data[0]
      @sheep_under_mouse.y = event_data[1]
    end
  end

  def release_sheep(event_data)
    if @sheep_under_mouse
      @sheep_under_mouse.release!
      @sheep_under_mouse = nil
    end
  end

end

class HookedGosuWindow
  def needs_cursor?
    true
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
