require 'gosu'
require_relative 'player'
require_relative 'enemy'
require_relative 'bullet'
require_relative 'explosion'

class SectorFive < Gosu::Window
  WIDTH = 800
  HEIGHT = 600
  ENEMY_FREQUENCY = 0.02

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Sector Five"
    @player = Player.new(self)
    @enemies = []
    @bullets = []
    @explosions = []
  end

  def draw
    @player.draw
    @enemies.each do |enemy|
      enemy.draw
    end
    @bullets.each do |bullet|
      bullet.draw
    end
    @explosions.each do |explosion|
      explosion.draw
    end
  end

  def update

    #player ship controls
    @player.turn_left if button_down?(Gosu::KbLeft)
    @player.turn_right if button_down?(Gosu::KbRight)
    @player.accelerate if button_down?(Gosu::KbUp)
    @player.move

    # creates a new enemy at intervals
    if rand() < ENEMY_FREQUENCY
      @enemies.push Enemy.new(self)
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
  end

  def button_down(id)

    # allows Esc key to exit the game
    if id == Gosu::KbEscape
      exit
    end

    # fires a bullet from Player ship when you press spacebar
    if id == Gosu::KbSpace
      @bullets.push Bullet.new(self, @player.x, @player.y, @player.angle)
    end
  end

end


window = SectorFive.new
window.show