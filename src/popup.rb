class PopupView < ActorView
  def draw(target, x_off, y_off, z)
    @screen ||= @stage.resource_manager.load_image 'popup.png'

    x = @actor.x
    y = @actor.y
    @screen.draw x, y, z
  end
end

class Popup < Actor
  has_behavior :graphical, layered: {layer: ZOrder::HudBackground}
  
  def setup
    super
    input_manager.reg :down, KbSpace do
      self.remove_self
    end
    color = [250,230,255,200]
    
    @label = spawn :label, text: opts[:msg], x: self.x, y: self.y, font: FONT, size: 25, color: color, layer: ZOrder::HudText
  end
  
  def draw(target)
    super
  end

end

