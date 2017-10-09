require 'gosu'
require_relative 'player'
require_relative 'enemy'
require_relative 'bullet'
require_relative 'explosion'
require_relative 'credit'

class SectorFive < Gosu::Window
  WIDTH = 800
  HEIGHT = 600
  ENEMY_FREQUENCY = 0.05
  MAX_ENEMIES = 100

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Sector Five"
    @background_image = Gosu::Image.new('images/start_screen.png')
    @scene = :start
    @start_music = Gosu::Song.new('sounds/Lost Frontier.ogg')
    @start_music.play(true)
  end

  def initialize_game
    @player = Player.new(self)
    @enemies = []
    @bullets = []
    @explosions = []
    @scene = :game
    @enemies_appeared = 0
    @enemies_destroyed = 0
    @game_music = Gosu::Song.new('sounds/Cephalopod.ogg')
    @game_music.play(true)
    @explosion_sound = Gosu::Sample.new('sounds/explosion.ogg')
    @shooting_sound = Gosu::Sample.new('sounds/shoot.ogg')
    @score_font = Gosu::Font.new(30)
    @score = 0
  end

  def initialize_end(fate)
    # displays different messages based on end conditions
    case fate
    when :count_reached
      @message = "You made it! You destroyed #{@enemies_destroyed} enemy ships"
      @message2 = "and #{100 - @enemies_destroyed} reached your base."
      @message3 = "Your final score was #{@score}."
    when :hit_by_enemy
      @message = "You were struck by an enemy ship."
      @message2 = "Before your ship was destroyed, "
      @message2 += "you took out #{@enemies_destroyed} enemy ships."
      @message3 = "Your final score was #{@score}."
    when :off_top
      @message = "You got too close to the enemy mother ship."
      @message2 = "Before your ship was destroyed, "
      @message2 += "you took out #{@enemies_destroyed} enemy ships."
      @message3 = "Your final score was #{@score}."
    end
    @bottom_message = "Press P to play again, or Q to quit."
    @message_font = Gosu::Font.new(28)
    
    # scrolls credits from a separate txt file
    @credits =[]
    y = 700
    File.open('credits.txt').each do |line|
      @credits.push(Credit.new(self, line.chomp, 100, y))
      y += 30
    end
    @scene = :end
    @end_music = Gosu::Song.new('sounds/FromHere.ogg')
    @end_music.play(true)
  end

  def draw
    case @scene
    when :start
      draw_start
    when :game
      draw_game
    when :end
      draw_end
    end    
  end

  def draw_start
    #displays the start screen image
    @background_image.draw(0,0,0)
  end

  def draw_game
    # draws the player ship
    @player.draw

    # draws a new enemy
    @enemies.each do |enemy|
      enemy.draw
    end

    # draws a new bullet
    @bullets.each do |bullet|
      bullet.draw
    end

    # draws a new explosion
    @explosions.each do |explosion|
      explosion.draw
    end

    @score_font.draw("Score: #{@score.to_s}", 20, 20, 2)
  end

  def draw_end
    # creates a "window" to view the credits, (x, y, width, height)
    clip_to(50, 140, 700, 360) do
      @credits.each do |credit|
        credit.draw
      end
    end
    # creates one red line to separate the credits "window" (0 and WIDTH are start and end points on X axis)
    # (x1, y1, GosuColor1, x2, y2, GosuColor2)
    draw_line(0,140,Gosu::Color::RED,WIDTH,140,Gosu::Color::RED)
    # (@message, x, y, ??, x-scaling-factor, y-scaling-factor, GosuColor)
    @message_font.draw(@message,40,40,1,1,1,Gosu::Color::FUCHSIA)
    @message_font.draw(@message2,40,70,1,1,1,Gosu::Color::FUCHSIA)
    @message_font.draw(@message3,40,100,1,1,1,Gosu::Color::YELLOW)
    draw_line(0,500,Gosu::Color::RED,WIDTH,500,Gosu::Color::RED)
    @message_font.draw(@bottom_message,180,540,1,1,1,Gosu::Color::AQUA)
  end

  def update
    case @scene
    when :game
      update_game
    when :end
      update_end
    end
  end

  def update_game
    #player ship controls
    @player.turn_left if button_down?(Gosu::KbLeft)
    @player.turn_right if button_down?(Gosu::KbRight)
    @player.accelerate if button_down?(Gosu::KbUp)
    @player.move

    # creates a new enemy at intervals
    if rand() < ENEMY_FREQUENCY
      @enemies.push Enemy.new(self)
      @enemies_appeared += 1
    end

    #moves each enemy in the enemies array
    @enemies.each do |enemy|
      enemy.move
    end

    # moves each bullet in the bullets array
    @bullets.each do |bullet|
      bullet.move
    end

    # enemies near a bullet will collide with bullet and explode
    @enemies.dup.each do |enemy|
      @bullets.dup.each do |bullet|
        distance = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y)
        if distance < enemy.radius + bullet.radius
          @enemies.delete enemy
          @bullets.delete bullet
          @explosions.push Explosion.new(self, enemy.x, enemy.y)
          @enemies_destroyed += 1
          @explosion_sound.play(0.3)
          @score += 1
        end
      end
    end

    # enemies near an explosion will also explode
    @explosions.dup.each do |explosion|
      @enemies.dup.each do |enemy|
        distance = Gosu.distance(enemy.x, enemy.y, explosion.x, explosion.y)
        if distance < enemy.radius + explosion.radius
          @enemies.delete enemy
          @explosions.push Explosion.new(self, enemy.x, enemy.y)
          @enemies_destroyed += 1
          @score += 1
        end
      end
    end

    # delete explosion from the explosions array when it's done exploding
    @explosions.dup.each do |explosion|
      @explosions.delete explosion if explosion.finished
    end

    # delete enemy from enemies array when it exits the bottom of the screen
    @enemies.dup.each do |enemy|
      if enemy.y > HEIGHT + enemy.radius
        @enemies.delete enemy
      end
    end

    # deletes bullet from bullets array unless the bullet is on-screen
    @bullets.dup.each do |bullet|
      @bullets.delete bullet unless bullet.onscreen?
    end

    # checks end condition if max enemies have appeared
    initialize_end(:count_reached) if @enemies_appeared > MAX_ENEMIES
    
    # checks end condition if hit by enemy ship
    @enemies.each do |enemy|
      distance = Gosu.distance(enemy.x, enemy.x, @player.x, @player.y)
      initialize_end(:hit_by_enemy) if distance < @player.radius + enemy.radius
    end

    # checks end condition if exit top of screen
    initialize_end(:off_top) if @player.y < -@player.radius
  end

  def update_end
    @credits.each do |credit|
      credit.move
    end
    if @credits.last.y < 150
      @credits.each do |credit|
        credit.reset
      end
    end
  end

  def button_down(id)
    case @scene
    when :start
      button_down_start(id)
    when :game
      button_down_game(id)
    when :end
      button_down_end(id)
    end

    # allows Esc key to exit the game
    if id == Gosu::KbEscape
      exit
    end
  end

  def button_down_start(id)
    initialize_game
  end

  def button_down_game(id)
    # fires a bullet from Player ship when you press spacebar
    if id == Gosu::KbSpace
      @bullets.push Bullet.new(self, @player.x, @player.y, @player.angle)
      @shooting_sound.play(0.3) # 0.3 modifies the sound volume to be quieter
    end
  end

  def button_down_end(id)
    if id == Gosu::KbP
      initialize_game
    end
    if id == Gosu::KbQ
      close
    end
  end

end

window = SectorFive.new
window.show