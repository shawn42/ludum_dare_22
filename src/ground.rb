class Ground < Actor
  has_behavior :graphical, layered: {layer: ZOrder::Ground}
end
