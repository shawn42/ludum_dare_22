class DemoStage < Stage
  BGCOLOR = [60,60,60]
  def setup
    super
    @sheep = spawn :sheep, x: 100, y: 100
    @clock = spawn :clock, x: 850, y: 10
    @sun = spawn :sun, clock: @clock
  end

  def draw(target)
    target.fill_screen BGCOLOR, 0
    super
  end
end

class Sun < Actor
  has_behavior :updatable, :graphical

  def setup
    @clock = opts[:clock]
  end

  def update(time)
  end
end
