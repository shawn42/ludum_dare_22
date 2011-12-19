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
