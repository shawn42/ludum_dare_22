class HungerMeterView < ActorView
  #COLOR = [250,250,255,200]
  def draw(target,x_off,y_off,z)
    @screen ||= @stage.resource_manager.load_image 'clock_bg.png'

    x = @actor.x
    y = @actor.y
    @screen.draw x, y, z
  end
end

class HungerMeter < Actor
  has_behavior :layered => {:layer => ZOrder::HudBackground}
  has_behavior :updatable

  def setup
    @label = spawn :label, layer: ZOrder::HudText, font: FONT, size: 30
    width = @label.font.text_width "Hunger:    "
    @label.x = self.x+15
    @label.y = self.y+20
    write_label
  end

  def write_label
    @label.text = "Hunger: #{@hunger}"
  end
  
  def hunger=(hunger)
    @hunger = hunger.ceil
    write_label
  end
  
  def subtract(amount)
    @hunger -= amount
    @hunger = 0 if @hunger < 0
    write_label
  end
end
