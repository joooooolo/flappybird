class Flappybird

  def initialize(args)
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
  end

  def render
    @args.outputs.solids << {x: 0, y: 0, w: @args.grid.w, h: @args.grid.h, r: 135, g: 206,b:235}
    @args.outputs.sprites << [@player]
  end
end
def tick(args)
  args.state.game ||= Flappybird.new(args)
  args.state.game.tick
end
$gtk.reset
