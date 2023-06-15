class FlappyBird

  TIMER = 10
  FPS = 60
  SPEED = 3
  PLAYER_SIZE = 40

  def initialize(args)
    @args = args
    @timer = TIMER * FPS
    @obstacles = []
    spawn_obstacles

    @player = {
      x: 300,
      y: 300,
      w: PLAYER_SIZE,
      h: PLAYER_SIZE,
      path: "sprites/circle/orange.png",

      velocity: 0
    }
    @score = 0
  end

  def tick
    render
    handle_timer
    moving_obstacles
    fall
    jump_player
    handle_collisions
  end

  def fall
    @player[:velocity] -= 0.2
    @player[:y] += @player[:velocity]
  end

  def jump_player
    if @args.inputs.keyboard.key_down.space
      @player[:velocity] = 6
    end
  end

  def handle_collisions

    if @player[:y] < @args.grid.y
      $gtk.reset
    end

    @obstacles.each do |obstacle|
      if @player.intersect_rect?(obstacle)
        $gtk.reset
      end

      if @player[:x] > obstacle[:x] && @player[:x] < obstacle[:x] + SPEED
        @score += 0.5
      end

    end

  end

  def render
    @args.outputs.solids << { x: 0, y: 0, w: @args.grid.w, h: @args.grid.h, r: 135, g: 206, b: 235 }
    @args.outputs.sprites << [@player, @obstacles]
    @args.outputs.labels << { x: 10, y: 10.from_top, text: "Score: #{@score.to_i}", size_enum: 10 }
  end

  def handle_timer
    @timer += 1
    spawn_obstacles if @timer % 200 == 0
  end

  def spawn_obstacles
    @random_number = rand(200) - 150
    @obstacles << {

      x: 1280,
      y:  450 + @random_number,
      w:  100,
      h:  720,
      path: "sprites/toppipe.png"

    }

    @obstacles << {

      x: 1280,
      y:    0 + @random_number - 420,
      w:  100,
      h:  720,
      path: "sprites/botpipe.png"

    }


  end

  def moving_obstacles
    @obstacles.each do |obstacle|
      obstacle[:x] -= SPEED
    end
  end
end

def tick(args)
  args.state.game ||= FlappyBird.new(args)
  args.state.game.tick
end

$gtk.reset
