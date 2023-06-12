class Flappybird
  TIMER = 10
  FPS = 60
  SPEED = 2

  def initialize(args)

    @args = args
    @obstacles = [

      {x: 1280, y: 450, w: 150, h: 650, r: 0, g: 128, b: 0},
      {x: 1280, y: 0, w: 150, h: 250, r: 0, g: 128, b: 0},
    ]
    @timer = TIMER*FPS

    @player = {
      x: 300,    y: 300,      w: 90,
      h: 75,
      path: "sprites/hexagon/orange.png",
    }
  end

  def tick
    render
    spawn_obstacles
    moving_obstacles
  end

  def render
    @args.outputs.solids << {x: 0, y: 0, w: @args.grid.w, h: @args.grid.h, r: 135, g: 206,b:235}
    @args.outputs.sprites << [@player, @obstacles]
  end

  def spawn_obstacles
@timer +=1
if @timer%200==0
    @obstacles << {x: 1280, y: 450, w: 150, h: 650, r: 0, g: 128, b:0}
    @obstacles << {x: 1280, y: 0, w: 150, h: 250, r: 0, g:128, b: 0}
end
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
   # args.state.moving_obstacles
  end
  $gtk.reset
