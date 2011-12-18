
class IntroStage < Stage
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
    spawn :label, text: "You are the last of the Wereshepards.", x: 20, y: 300, font: FONT, size: 45, color: color,layer: ZOrder::HudText
    spawn :label, text: "You must breed enough sheep to feed your evil soul at night.", x: 20, y: 410, font: FONT, size: 45, color: color, layer: ZOrder::HudText
    spawn :label, text: "Press SPACE to begin tending your flock...", x: 20, y: 700, font: FONT, size: 60, color: color, layer: ZOrder::HudText
  end
  
  def update(time)
    super
    fire :next_stage if @continue
  end
 
  def curtain_down
    fire :remove_me
  end

end

