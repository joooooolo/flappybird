def tick(args)
  args.outputs.labels << { x: 640, y: 540, text: "Hello World!", size_enum: 5, alignment_enum: 1 }

  args.outputs.labels << {
    x: 640,
    y: 500,
    text: "Docs located at ./docs/docs.html and 100+ samples located under ./samples",
    size_enum: 5,
    alignment_enum: 1
  }

  args.outputs.labels << {
    x: 640,
    y: 460,
    text: "Join the Discord server! https://discord.dragonruby.org",
    size_enum: 5,
    alignment_enum: 1
  }

  args.outputs.sprites << {
    x: 576,
    y: 280,
    w: 128,
    h: 101,
    path: "dragonruby.png",
    angle: args.state.tick_count
  }

  args.outputs.labels << {
    x: 640,
    y: 60,
    text: "./mygame/app/main.rb",
    size_enum: 5,
    alignment_enum: 1
  }
end
