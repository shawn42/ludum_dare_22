
class StarvedEndingStage < Stage
  def setup
    super
    mid_screen = viewport.width/2
    @background = spawn :background, x: mid_screen, y: viewport.height/2
    @ground = spawn :ground, x: mid_screen, y: viewport.height/2
    @continue = false
    @input_manager.reg :keyboard_down, KbSpace do
      @continue = true
    end
    color = [0,0,0,200]
    spawn :label, text: "You are hungry, but you cannot eat. You die alone.", x: 20, y: 410, font: FONT, size: 48, color: color, layer: ZOrder::HudText
  end
  
  def update(time)
    super
    exit if @continue
  end
 
  def curtain_down
    fire :remove_me
  end

end

