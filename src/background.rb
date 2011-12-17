
class Background < Actor
  has_behavior :graphical, layered: {layer: ZOrder::Sky}
  def setup
    @day_background = resource_manager.load_image 'background.jpg'
    graphical.image = @day_background
  end
end
