
class Background < Actor
  has_behaviors :graphical, layered: {layer: 0}
  def setup
    graphical.image = resource_manager.load_image 'background.jpg'
  end
end
