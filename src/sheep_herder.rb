class SheepHerder < Actor
  attr_accessor :sheepies
  def setup
    # TODO build some sheep
    @sheepies = []
    @sheepies << spawn(:sheep, x: 100, y: 100)
    @sheepies << spawn(:sheep, x: 400, y: 200)

    input_manager.reg :mouse_down, MsLeft do |event|
      check_for_sheep_under_mouse event[:data]
    end
    input_manager.reg :mouse_up, MsLeft do |event|
      release_sheep event[:data]
    end
    input_manager.reg :mouse_motion do |event|
      move_sheep event[:data]
    end
  end

  def check_for_sheep_under_mouse(event_data)
    return unless can_handle_sheep?
    click_x = event_data[0]
    click_y = event_data[1]
    target_sheep = @sheepies.detect { |sheep| sheep.collide_point? click_x, click_y }
    if target_sheep
      @click_x_offset = target_sheep.x - click_x
      @click_y_offset = target_sheep.y - click_y
      @sheep_under_mouse = target_sheep
      @sheep_under_mouse.pickup!
    end
  end

  def move_sheep(event_data)
    return unless can_handle_sheep?
    if @sheep_under_mouse
      @sheep_under_mouse.x = event_data[0] + @click_x_offset
      @sheep_under_mouse.y = event_data[1] + @click_y_offset
    end
  end

  def release_sheep(event_data)
    return unless can_handle_sheep?
    if @sheep_under_mouse
      @sheep_under_mouse.release!
      @sheep_under_mouse = nil
      @click_x_offset = nil
      @click_y_offset = nil
    end
  end

  def can_handle_sheep?
    @enabled
  end

  def enable!
    @enabled = true
  end

  def disable!
    @enabled = false
  end

end
