
class StarvedEndingStage < Stage
  def setup
    super
    mid_screen = viewport.width/2
    @background = spawn :background, x: mid_screen, y: viewport.height/2
    @ground = spawn :ground, x: mid_screen, y: viewport.height/2
    @continue = false
    @input_manager.reg :keyboard_down, KbSpace do
      sleep 1
      @continue = true
    end
  end
  
  def update(time)
    super
    fire :change_stage, :intro if @continue
  end
 
  def curtain_raising(opts)
    @days = opts[:days]
    color = [0,0,0,200]
    spawn :label, text: "You are hungry, but you cannot eat. You die alone.", x: 20, y: 310, font: FONT, size: 48, color: color, layer: ZOrder::HudText
    suffix = "s" unless @days == 1
    spawn :label, text: "You survived #{@days} day#{suffix}!", x: 220, y: 510, font: FONT, size: 80, color: color, layer: ZOrder::HudText
  end

  def curtain_down
    fire :remove_me
  end

end

