class HookedGosuWindow
  def needs_cursor?
    true
  end
end


class Label
  def height
    @font ? @font.height : 0
  end
end

class Graphical
  def height
    image ? image.height : 0
  end
end
class Animated
  def height
    image ? image.height : 0
  end
end
