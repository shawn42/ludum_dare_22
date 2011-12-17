
class Background < Actor
  has_behaviors :graphical, layered: {layer: 0}
  def setup
    @day_background = resource_manager.load_image 'background.jpg'
    @night_background = resource_manager.load_image 'background_night.jpg'
    graphical.image = @day_background
  end

  def transition_to_day
    graphical.image = @day_background
  end

  def transition_to_night
    graphical.image = @night_background
  end
end
