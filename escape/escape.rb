require 'gosu'
require 'chipmunk'
require_relative 'camera'
require_relative 'boulder'
require_relative 'platform'
require_relative 'wall'
require_relative 'chip'
require_relative 'moving_platform'

class Escape < Gosu::Window
  DAMPING = 0.90
  GRAVITY = 400.0
  BOULDER_FREQUENCY = 0.01 # to make fewer boulders fall, change SPEED_LIMIT in boulder.rb

  attr_reader :space

  def initialize
    super(800, 800)
    self.caption = "Escape"
    @game_over = false
    @space = CP::Space.new
    @background = Gosu::Image.new('images/background.png', tileable: true)
    @space.damping = DAMPING
    @space.gravity = CP::Vec2.new(0.0, GRAVITY)
    @boulders = []
    @platforms = make_platforms

    @floor = Wall.new(self, 800, 1610, 1600, 20)
    @left_wall = Wall.new(self, -10, 800, 20, 1600)
    @right_wall = Wall.new(self, 1610, 870, 20, 1460)

    @player = Chip.new(self, 70, 1500)
    @camera = Camera.new(self, 1600, 1600)
    @camera.center_on(@player, 400, 200)

    @exit_image = Gosu::Image.new('images/exit.png')
    @font = Gosu::Font.new(40)
    @font_small = Gosu::Font.new(18)

    @music = Gosu::Song.new('sounds/zanzibar.ogg')
    @music.play(true)
  end

  def update
    @camera.center_on(@player, 400, 200)
    if @game_over == false
      @seconds = (Gosu.milliseconds / 1000).to_i
      10.times do
        @space.step(1.0/600)
      end
      if rand < BOULDER_FREQUENCY
        @boulders.push Boulder.new(self, 200 + rand(1200), -20)
      end
      @player.check_footing(@platforms + @boulders)
      @platforms.each do |platform|
        platform.move if platform.respond_to?(:move)
      end
      if button_down?(Gosu::KbRight)
        @player.move_right
      elsif button_down?(Gosu::KbLeft)
        @player.move_left
      else
        @player.stand
      end
      if @player.x > 1620
        @game_over = true
        @win_time = Gosu.milliseconds
      end
    end # end UNLESS game_over LOOP
  end

  def draw
    @camera.view do # draws the background tile image
      (0..3).each do |row|
        (0..1).each do |column|
          @background.draw(799 * column, 529 * row, 0)
        end
      end
      @boulders.each do |boulder|
        boulder.draw
      end
      @platforms.each do |platform|
        platform.draw
      end
      @player.draw
      @exit_image.draw(1450, 30, 2) # draws exit sign image
    end # end camera.view loop
    if @game_over == false
      @font.draw("#{@seconds}", 10, 20, 3, 1, 1, 0xff00ff00)
    else
      @font.draw("#{@win_time/1000}", 10, 20, 3, 1, 1, 0xff00ff00)
      draw_credits
    end
  end

  def draw_credits
    color = 0xff00ff00
    @font.draw("Game Over", 240, 150, 3, 2, 2, color)
    @font_small.draw("Images from the SpriteLab Collection", 100, 300, 3, 2, 2, color)
    @font_small.draw("by WidgetWorx under the terms of the", 100, 350, 3, 2, 2, color)
    @font_small.draw("Common Public License", 100, 400, 3, 2, 2, color)
    @font_small.draw("Music: Zanzibar, by Kevin MacLeod", 100, 500, 3, 2, 2, color)
    @font_small.draw("(incompetech.com)", 100, 550, 3, 2, 2, color)
    @font_small.draw("Licensed under", 100, 600, 3, 2, 2, color)
    @font_small.draw("Creative Commons: By Attribution 3.0", 100, 650, 3, 2, 2, color)
    @font_small.draw("http://creativecommons.org/licenses/by/3.0/", 100, 700, 3, 2, 2, color)
  end

  def make_platforms
    platforms = []
    # platforms.push Platform.new(self, 150, 700)
    # platforms.push Platform.new(self, 320, 650)
    # platforms.push Platform.new(self, 150, 500)
    # platforms.push Platform.new(self, 470, 550)
    # platforms.push MovingPlatform.new(self,580,600,70,:vertical)
    # platforms.push Platform.new(self,320,440)
    # platforms.push Platform.new(self,600,150)
    # platforms.push Platform.new(self,700,450)
    # platforms.push Platform.new(self,580,300)
    # platforms.push MovingPlatform.new(self,190,330,50,:vertical)
    # platforms.push MovingPlatform.new(self,450,230,70,:horizontal)
    # platforms.push Platform.new(self,750,140)
    # platforms.push Platform.new(self,700,700)
    return platforms
  end

  def button_down(id)
    if id == Gosu::KbSpace
      @player.jump
    end
    if id == Gosu::KbEscape
      close
    end
  end

end

window = Escape.new
window.show
