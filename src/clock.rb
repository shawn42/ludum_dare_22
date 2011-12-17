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
  has_behavior :layered => {:layer => 998}
  has_behavior :timed

  MORNING = 8*60
  NIGHTFALL = 20*60
  
  def setup
    @label = spawn :label, layer: 0
    text = "00:00"
    width = @label.font.text_width text
    @label.x = self.x+(width/2)
    @label.y = self.y+20
    @label.text = text
    @time = 0

    add_timer 'tick', 1000 do
      bump
      @label.text = "#{'%02d' % (@time/60)}:#{'%02d' % (@time%60)}"
    end
  end
  
  def bump
    @time += 30
    @time = @time % 1440
    if @time == MORNING
      fire :transition_to_day
    elsif @time == NIGHTFALL
      fire :transition_to_night
    end
  end

  def percent_of_day
    @time / 1440.0
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
