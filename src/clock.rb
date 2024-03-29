class ClockView < ActorView
  def draw(target,x_off,y_off,z)
    @screen ||= @stage.resource_manager.load_image 'clock_bg.png'

    x = @actor.x
    y = @actor.y
    @screen.draw x, y, z
  end
end

class Clock < Actor
  has_behavior :layered => {:layer => ZOrder::HudBackground}
  has_behavior :timed, :updatable

  MORNING = 7*60*1000
  NIGHTFALL = 19*60*1000

  attr_reader :day

  def setup
    @label = spawn :label, layer: ZOrder::HudText, size: 45, font: FONT
    text = "00:00"
    width = @label.font.text_width text
    @label.x = self.x+10
    @label.y = self.y+2
    @label.text = text
    @time = 0
    @day = 0
    @night = true

    @day_label = spawn :label, layer: ZOrder::HudText, size: 28, font: FONT
    @day_label.text = "Day #{@day}"
    @day_label.x = self.x+10
    @day_label.y = self.y+35

    add_timer 'tick', 1000 do
      truncated_time = @time / 1000.0
      hour = '%02d' % (truncated_time/60)

      minute = ((truncated_time%60).round.to_i)
      minute = minute < 30 ? 0 : 30
      minute = '%02d' % minute

      @label.text = "#{hour}:#{minute}"

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
  
  def started?
    @time > 0 && @day > 0
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
