class Flappybird

  SPEED = 10

  def initialize(args)

    @obstacles = [
      {x: 200, y: 450, w: 150, h: @args.grid.h, r: 0, g: 128, b: 0},
      {x: 200, y: 0, w: 150, h: 250, r: 0, g: 128, b: 0}
    ]

    @args =args

    @player = {
      x: 300,
      y: 300,
      w: 90,
      h: 75,
      path: "sprites/hexagon/orange.png",
    }
  end

  def tick
    render
    moving_obstacles
  end

  def render
    @args.outputs.solids << {x: 0, y: 0, w: @args.grid.w, h: @args.grid.h, r: 135, g: 206,b:235}
    # @args.outputs.solids << {x: 200 , y:0, w: 150, h: 250, r: 0, g: 128, b: 0}
    # @args.outputs.solids << {x: 200, y: 450, w: 150, h: @args.grid.h, r: 0, g: 128, b: 0}
    @args.outputs.sprites << [@player, @obstacles]
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
