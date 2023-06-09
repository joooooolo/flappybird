class FlappyBird

  TIMER = 10
  FPS = 60
  SPEED = 3
  PLAYER_SIZE = 50
  BACKGROUND_SPEED = 1.5
  def initialize(args)
    @args = args
    @scene = :main_menu
    @timer = TIMER * FPS
    @obstacles = []
    spawn_obstacles
    @player = {
      x: 300,
      y: 300,
      w: PLAYER_SIZE,
      h: PLAYER_SIZE,
      path: "sprites/poke.png",
      source_x: 0,
      source_y: 80,
      source_w: 80,
      source_h: 80,
      velocity: 0
    }
    @backgroundsprites = []
    spawn_background
    @score = 0
  end


  def tick
    send "#{@scene}_tick"
  end

  def game_tick
    render
    handle_timer
    moving_obstacles
    fall
    handle_collisions
    handle_input
    moving_background
  end

  def fall
    @player[:velocity] -= 0.2
    @player[:y] += @player[:velocity]
  end

  def main_menu_tick
    @args.outputs.labels << [
      {
        x: @args.grid.w / 2,
        y: @args.grid.h / 2,
        text: "Get ready...",
        size_enum: 25,
        alignment_enum: 1,
        vertical_alignment_enum: 1
      },
      {
        x: 40,
        y: 50,
        text: "Escape or Start to pause",
      },
      {
        x: 50.from_right,
        y: 75,
        text: "Space or A to start",
        size_enum: 10,
        alignment_enum: 2
      }

    ]

    if jump_button_pressed?
      @scene = :game
    end
  end

  def pause_tick
    @args.outputs.labels << [
      {
        x: @args.grid.w / 2,
        y: @args.grid.h / 2,
        text: "It's okay, take a breather.",
        size_enum: 25,
        alignment_enum: 1,
        vertical_alignment_enum: 1
      },

      {
        x: 40,
        y: 50,
        text: "Escape or Start to pause",
      },
      {
        x: 50.from_right,
        y: 75,
        text: "Space or A to continue",
        size_enum: 10,
        alignment_enum: 2
      }
    ]

    if jump_button_pressed?
      @scene = :game
    end
  end

  def game_over_tick
    @high_score ||= @args.gtk.read_file("high_score").to_i

    if !@high_score_saved && @score > @high_score
      @args.gtk.write_file("high_score", @score.to_s)
      @high_score_saved = true
    end

    @args.outputs.labels << [
      {
        x: @args.grid.w / 2,
        y: @args.grid.h / 2 + 40,
        text: "Game Over!",
        size_enum: 25,
        alignment_enum: 1,
        vertical_alignment_enum: 1
      },
      {
        x: @args.grid.w / 2,
        y: @args.grid.h / 2 - 30,
        text: "Score: #{@score.to_i}",
        size_enum: 15,
        alignment_enum: 1,
        vertical_alignment_enum: 1
      },
      {
        x: @args.grid.w / 2,
        y: @args.grid.h / 2 - 80,
        text: @high_score_saved ? "New high score!" : "High score: #{@high_score.to_i}",
        size_enum: 15,
        alignment_enum: 1,
        vertical_alignment_enum: 1
      },
      {
        x: 50.from_right,
        y: 75,
        text: "Fire to restart",
        size_enum: 10,
        alignment_enum: 2
      }
    ]

    if jump_button_pressed?
      $gtk.reset
    end
  end

  def handle_input
    if @args.inputs.keyboard.key_down.escape
      @scene = :pause
    end
    if jump_button_pressed?
      @args.audio[:flap] = {input: "sounds/flap.mp3"}
      @player[:velocity] = 5.5
    end
  end

  def jump_button_pressed?
    @args.inputs.keyboard.key_down.space
  end

  def handle_collisions

    if @player[:y] < @args.grid.y
      @scene = :game_over
      @args.audio[:die] = {input: "sounds/die.mp3"}
    end

    @obstacles.each do |obstacle|
      if @player.intersect_rect?(obstacle)

        @args.audio[:die] = {input: "sounds/die.mp3"}
        @scene = :game_over
      end
      #(obstacle[:x]...obstacle[:x] + SPEED).include?(@player[:x])
      if @player[:x] > obstacle[:x] && @player[:x] < obstacle[:x] + SPEED

        # "0.5*2 obstacles -> 1 point"
        @score += 0.5
        @args.audio[:point] = {input: "sounds/point.mp3"}
      end
    end
  end

  def render
    @player[:source_x] = 0.frame_index(count: 4, hold_for: 8, repeat: true) * 80
    @args.outputs.sprites << [@backgroundsprites,@player, @obstacles]
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
      path: "sprites/toppipe.png",

      flip_vertically: true

    }

  end
  def spawn_background

    @backgroundsprites << {
      x:0,
      y:0,
      w:@args.grid.w,
      h:@args.grid.h,
      path: "sprites/under.png"
    }

    @backgroundsprites << {

    x:1280,
    y:0,
    w:@args.grid.w + BACKGROUND_SPEED,
    h:@args.grid.h,
    path: "sprites/under.png"
     }

end

  def moving_background

    @backgroundsprites.each do |o|#{ |o| o[:x] -= BACKGROUND_SPEED }
      o[:x] -= BACKGROUND_SPEED
    if o[:x] <= -@args.grid.w
    o[:x] = @args.grid.w * (@backgroundsprites.length - 1)
    end
    @backgroundsprites.reject!{ |o| o[:x] < -1280 }
  end
  end

  def moving_obstacles
    @obstacles.each { |o| o[:x] -= SPEED }
    @obstacles.reject!{ |o| o[:x] < -100 }
  end
end

def tick(args)
  args.state.game ||= FlappyBird.new(args)
  args.state.game.tick
end

$gtk.reset
