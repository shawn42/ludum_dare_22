class DemoStage < Stage
  BGCOLOR = [60,60,60]
  def setup
    super
    @background = spawn :background, :x => viewport.width/2, :y => viewport.height/2

    @clock = spawn :clock, x: 850, y: 10
    @sun = spawn :sun, x: 0, y: 200, clock: @clock, offset: (Math::PI/2.0)
    @moon = spawn :moon, x: 0, y: 200, clock: @clock, offset: -1 * (Math::PI/2.0)

    @sheep_herder = spawn :sheep_herder

    @clock.when :transition_to_day do
      @sheep_herder.enable!
    end
    @clock.when :transition_to_night do
      @sheep_herder.disable!
    end
    input_manager.reg :down, KbD do
      @clock.daytime!
    end
    input_manager.reg :down, KbN do
      @clock.nighttime!
    end

  end

  def draw(target)
    target.fill_screen BGCOLOR, 0
    super
  end

end
