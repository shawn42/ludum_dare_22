
class IntroStage < Stage
  def setup
    super
    mid_screen = viewport.width/2
    #@background = spawn :background, x: mid_screen, y: viewport.height/2
    #@ground = spawn :ground, x: mid_screen, y: viewport.height/2

    @input_manager.reg :keyboard_down, KbSpace do
      fire :next_stage
    end
    color = [200,230,255,200]
    spawn :label, text: "You are the last of the Wereshepards.", x: 20, y: 100, font: FONT, size: 45, color: color
    spawn :label, text: "You must breed enough sheep to feed your evil soul at night.", x: 20, y: 210, font: FONT, size: 45, color: color
    spawn :label, text: "Press SPACE to begin tending your flock...", x: 20, y: 700, font: FONT, size: 60, color: color
  end
  
  def draw(target)
    super
  end

  def curtain_down
    fire :remove_me
  end

end

