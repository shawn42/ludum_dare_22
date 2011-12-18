class ClockView < ActorView
  #COLOR = [250,250,255,200]
  def draw(target,x_off,y_off,z)
    #text = "#{@actor.score.to_s} lbs."

    #@font ||= @stage.resource_manager.load_font 'Emulator.ttf', 16
    @screen ||= @stage.resource_manager.load_image 'clock_bg.png'

    x = @actor.x
    y = @actor.y
    @screen.draw x, y, z
    #@font.draw text, x,y,z, 1,1, target.convert_color(COLOR)
  end
end

class Clock < Actor
  has_behavior :layered => {:layer => ZOrder::HudBackground}
  has_behavior :timed, :updatable

  MORNING = 7*60*1000
  NIGHTFALL = 19*60*1000

  def setup
    @label = spawn :label, layer: ZOrder::HudText
    text = "00:00"
    width = @label.font.text_width text
    @label.x = self.x+20
    @label.y = self.y+20
    @label.text = text
    @time = 0
    @day = 0
    @night = true

    @day_label = spawn :label, layer: ZOrder::HudText, size: 25
    @day_label.text = "Day #{@day}"
    @day_label.x = self.x+90
    @day_label.y = self.y+24

    add_timer 'tick', 1000 do
      truncated_time = @time / 1000.0
      @label.text = "#{'%02d' % (truncated_time/60)}:#{'%02d' % (truncated_time.round%60)}"
      if truncated_time < 30
        @day_label.text = "Day #{@day}"
      end
    end
  end
  
  def update(time)
    @time += (30 * time)
    if @time >= 1440000
      @day += 1
      @time = 0
    end
    bump
  end
  
  def bump
    if @night && @time >= MORNING && @time < NIGHTFALL
      @night = false
      fire :transition_to_day
    elsif !@night && @time > NIGHTFALL
      @night = true
      fire :transition_to_night
    end
  end

  def percent_of_day
    @time / 1440000.0
  end

  def daytime!
    @time = MORNING
    fire :transition_to_day
  end

  def nighttime!
    @time = NIGHTFALL
    fire :transition_to_night
  end

  def daytime?
    @time >= MORNING && @time < NIGHTFALL
  end

  def nighttime?
    !daytime?
  end
end
