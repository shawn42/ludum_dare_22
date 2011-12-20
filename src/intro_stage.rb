
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
    scale = 1.4
    spawn :label, text: "You are the last of the Wereshepherds.", x: 20, y: 300, font: FONT, size: 45, color: color,layer: ZOrder::HudText
    spawn :icon, image: 'were_shepherd/shepherd/0', x: 880, y: 50, layer: ZOrder::HudBackground, x_scale: scale, y_scale: scale

    spawn :label, text: "You must breed enough sheep to feed your evil soul at night.", x: 20, y: 410, font: FONT, size: 45, color: color, layer: ZOrder::HudText
    spawn :label, text: "Press SPACE to begin tending your flock...", x: 20, y: 700, font: FONT, size: 60, color: color, layer: ZOrder::HudText

    spawn :icon, image: :chick_sheep, x: 50, y: 490, layer: ZOrder::HudBackground, x_scale: scale, y_scale: scale

    spawn :label, text: "+", x: 240, y: 460, font: FONT, size: 160, color: color, layer: ZOrder::HudText

    spawn :icon, image: :dude_sheep, x: 340, y: 490, layer: ZOrder::HudBackground, x_scale: scale, y_scale: scale

    spawn :label, text: "=", x: 500, y: 460, font: FONT, size: 160, color: color, layer: ZOrder::HudText

    spawn :icon, image: :dude_sheep, x: 600, y: 480, layer: ZOrder::HudBackground, x_scale: scale, y_scale: scale
    spawn :icon, image: :chick_sheep, x: 750, y: 490, layer: ZOrder::HudBackground, x_scale: -scale, y_scale: scale
    spawn :censor_box, box: Rect.new(600, 500, 140, 90)

    spawn :label, text: "=", x: 780, y: 460, font: FONT, size: 160, color: color, layer: ZOrder::HudText

    spawn :icon, image: :baby_sheep, x: 880, y: 510, layer: ZOrder::HudBackground, x_scale: scale, y_scale: scale
  end
  
  def update(time)
    super
    fire :next_stage if @continue
  end
 
  def curtain_down
    fire :remove_me
  end

end

