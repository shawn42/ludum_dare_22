
class Background < Actor
  has_behavior :graphical, layered: {layer: ZOrder::Sky}
  def setup
    @day_background = resource_manager.load_image 'background.png'
    @night_background = resource_manager.load_image 'night_background.png'
    graphical.image = @day_background
  end
  
  def day!
    graphical.image = @day_background
  end
  
  def night!
    graphical.image = @night_background
  end    
end
