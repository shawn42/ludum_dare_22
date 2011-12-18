
class IntroStage < Stage
  def setup
    super
    mid_screen = viewport.width/2
    #@background = spawn :background, x: mid_screen, y: viewport.height/2
    #@ground = spawn :ground, x: mid_screen, y: viewport.height/2

    @input_manager.reg :keyboard_down, KbSpace do
      fire :next_stage
    end
    spawn :label, text: "You are the last of the Wereshepards.", x: 20, y: 10, font: 'SueEllenFrancisco.ttf', size: 110, color: [255,255,255,255]
    spawn :label, text: "You must breed enough sheep to feed your evil soul at night.", x: 20, y: 110, font: 'SueEllenFrancisco.ttf', size: 110
    spawn :label, text: "Press Space to begin tending your flock...", x: 20, y: 210, font: 'SueEllenFrancisco.ttf', size: 110
  end
  
  def draw(target)
    super
  end

  def curtain_down
    fire :remove_me
  end

end

