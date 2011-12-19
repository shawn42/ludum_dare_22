class SheepHerder < Actor
  has_behavior :audible

  attr_accessor :sheepies
  def setup
    # TODO build some sheep
    @sheepies = []
    @clock = opts[:clock]

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

  def spawn_initial_sheep
    spawn_sheep(gender: :dude, age:1, x: 100, y: 100)
    spawn_sheep(gender: :chick,age:1, x: 400, y: 200)
    spawn_sheep(gender: :dude, age:0, x: 400, y: 400)
  end

  def birth_baby(sheep)
    play_sound :baby
    bb = sheep.bb
    spawn_sheep age: 0, gender: [:dude, :chick].sample, x: bb.left, y: bb.top
  end

  def spawn_sheep(args)
    sheep = spawn(:sheep, args.merge(clock: @clock))
    sheep.when :did_the_hump do
      birth_baby sheep
    end
    @sheepies << sheep
  end

  def check_for_sheep_under_mouse(event_data)
    return unless can_handle_sheep?
    click_x = event_data[0]
    click_y = event_data[1]
    target_sheep = find_sheep click_x, click_y
    if target_sheep
      @click_x_offset = target_sheep.x - click_x
      @click_y_offset = (target_sheep.y - click_y) - Sheep::PICK_UP_ALTITUDE
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

      target_sheep = find_mate_for @sheep_under_mouse, *event_data
      @sheep_under_mouse.release!
      @sheep_under_mouse.mate(target_sheep) if target_sheep
      @sheep_under_mouse = nil
      @click_x_offset = nil
      @click_y_offset = nil
    end
  end
  def release_sheep!
    if @sheep_under_mouse
      @sheep_under_mouse.release!
      @sheep_under_mouse = nil
    end
    @click_x_offset = nil
    @click_y_offset = nil
  end

  def find_sheep(x,y)
    @sheepies.detect { |sheep| !sheep.dead? && !sheep.mating? && sheep.collide_point?(x, y) }
  end

  def find_mate_for(sheep, x, y)
    @sheepies.detect { |s| s.collide_point?(x, y) && sheep.can_mate?(s) }
  end

  def can_handle_sheep?
    @enabled
  end

  def enable!
    @enabled = true
  end

  def disable!
    self.release_sheep!
    @enabled = false
  end

  def age_sheep
    @sheepies.each { |sheep| sheep.age! }
    @sheepies.delete_if { |sheep| sheep.dead? }
  end

  def are_sheep_left?
    @sheepies.size > 0
  end
end
