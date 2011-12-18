HORIZON = 240

class MainStage < Stage
  BGCOLOR = [60,60,60]
  NIGHT_OVERLAY_COLOR = [60,60,60,100]
  def setup
    super
    mid_screen = viewport.width/2
    @background = spawn :background, x: mid_screen, y: viewport.height/2
    @ground = spawn :ground, x: mid_screen, y: viewport.height/2

    @clock = spawn :clock, x: 950, y: 10
    @hunger_meter = spawn :hunger_meter, x: 50, y: 10
    @sun = spawn :sun, x: 0, y: 200, clock: @clock, offset: (Math::PI/2.3)
    @moon = spawn :moon, x: 0, y: 200, clock: @clock, offset: -1 * (Math::PI/2.0)

    @were_shepard = spawn :were_shepard, x: 500, y: 500, clock: @clock
    @were_shepard.when :remove_me do
      # dead... you lose
      # change_stage_to :you_lose
      puts "you died"
      exit
    end
    @sheep_herder = spawn :sheep_herder, clock: @clock

    spawn :popup, x: 100, y: 400, msg: "Drag sheep together to breed!"

    @were_shepard.when :attack do |dir|
      sheep = @sheep_herder.find_sheep(@were_shepard.x + 40*dir, @were_shepard.y)
      @were_shepard.eat sheep.injure! if sheep
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
    @were_shepard.when :require_food do |hunger|
      @hunger_meter.hunger = hunger
    end
    @were_shepard.when :ate_food do |amount|
      @hunger_meter.subtract amount
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
