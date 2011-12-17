class DemoStage < Stage
  BGCOLOR = [60,60,60]
  NIGHT_OVERLAY_COLOR = [60,60,60,100]
  def setup
    super
    mid_screen = viewport.width/2
    @background = spawn :background, x: mid_screen, y: viewport.height/2
    @ground = spawn :ground, x: mid_screen, y: viewport.height/2 + 90

    @clock = spawn :clock, x: 950, y: 10
    @sun = spawn :sun, x: 0, y: 200, clock: @clock, offset: (Math::PI/2.0)
    @moon = spawn :moon, x: 0, y: 200, clock: @clock, offset: -1 * (Math::PI/2.0)

    @sheep_herder = spawn :sheep_herder
    @were_shepard = spawn :were_shepard, x: 500, y: 500, clock: @clock
    @were_shepard.when :remove_me do

    end

    @clock.when :transition_to_day do
      @sheep_herder.enable!
      @sheep_herder.age_sheep
      sound_manager.play_sound :rooster
      @background.day!
    end
    @clock.when :transition_to_night do
      @sheep_herder.disable!
      sound_manager.play_sound :wolf
      @background.night!
    end
    input_manager.reg :down, Kb0 do
      @clock.daytime!
    end
    input_manager.reg :down, Kb9 do
      @clock.nighttime!
    end

    @clock.daytime!
    @sheep_herder.spawn_initial_sheep
  end

  def draw(target)
    target.fill_screen BGCOLOR, ZOrder::BackgroundColor
    super
    target.fill_screen NIGHT_OVERLAY_COLOR, ZOrder::NightOverlay if @clock.nighttime?
  end

end
