# class PopupView < ActorView
  # def draw(target, x_off, y_off, z)
    # @screen ||= @stage.resource_manager.load_image 'clock_bg.png'
# 
    # x = @actor.x
    # y = @actor.y
    # @screen.draw x, y, z
  # end
# end

class Popup < Actor
  has_behavior :graphical, layered: {layer: ZOrder::HudText}
  
  def setup
    super
    @input_manager.reg :keyboard_down, KbSpace do
      fire :remove_me
    end
    color = [200,230,255,200]
    
    @label = spawn :label, text: opts[:msg], x: 0, y: 0, font: FONT, size: 25, color: color, layer: ZOrder::HudText
  end
  
  def draw(target)
    super
  end

end

