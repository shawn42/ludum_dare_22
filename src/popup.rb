class PopupView < ActorView
  def draw(target, x_off, y_off, z)
    @screen ||= @stage.resource_manager.load_image 'popup.png'

    x = @actor.x
    y = @actor.y
    @screen.draw_rot x, y, z, 0, 0.01, 0.2, 2, 2 #, 0xffffffff, mode=:default
  end
end

class Popup < Actor
  has_behavior :graphical, layered: {layer: ZOrder::HudBackground}

  def setup
    super
    input_manager.reg :down, KbSpace do
      @label.remove_self
      @dismiss.remove_self
      self.remove_self
    end
    color = [250,230,255,200]

    @label = spawn :label, text: opts[:msg], x: self.x, y: self.y, font: FONT, size: 25, color: color, layer: ZOrder::HudText
    @dismiss = spawn :label, text: '(Hit SPACE)', x: self.x, y: self.y+20, font: FONT, size: 25, color: color, layer: ZOrder::HudText
  end
  
end

