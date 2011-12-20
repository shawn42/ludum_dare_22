class IconView < GraphicalActorView
end

class Icon < Actor
  attr_accessor :image, :x_scale, :y_scale
  def setup
    layer = opts[:layer] || 1
    is(:layered) unless is?(:layered)
    layered.layer = layer
    @image = stage.resource_manager.load_image "#{opts[:image]}.png"
    @x_scale = opts[:x_scale] || 1
    @y_scale = opts[:y_scale] || 1
  end
end
