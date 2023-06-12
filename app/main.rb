class Flappybird
  TIMER = 10
  FPS = 60
  SPEED = 2
  PLAYER_SIZE = 40

  def initialize(args)
    @args = args
    @timer = TIMER*FPS

    @obstacles = []
    spawn_obstacles

    @player = {
      x: 300,
      y: 300,
      w: PLAYER_SIZE,
      h: PLAYER_SIZE,
      path: "sprites/hexagon/orange.png",

      velocity: 0
    }
  end

  def tick
    render
    handle_timer
    moving_obstacles
    fall
    jump_player
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

  def render
    @args.outputs.solids << { x: 0, y: 0, w: @args.grid.w, h: @args.grid.h, r: 135, g: 206, b: 235 }
    @args.outputs.sprites << [@player, @obstacles]
    @args.outputs.labels << { x: 50, y: 50, text: @player[:velocity].to_i }
  end

  def handle_timer
    @timer += 1
    spawn_obstacles if @timer % 200 == 0
  end

  def spawn_obstacles
    @obstacles << { x: 1280, y: 450, w: 150, h: 650, r: 0, g: 128, b: 0 }
    @obstacles << { x: 1280, y: 0, w: 150, h: 250, r: 0, g: 128, b: 0 }
  end

  def moving_obstacles
    @obstacles.each do |obstacle|
      obstacle[:x] -= SPEED
    end
  end
end

def tick(args)
  args.state.game ||= Flappybird.new(args)
  args.state.game.tick
end

$gtk.reset
