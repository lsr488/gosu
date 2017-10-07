require 'gosu'

class WhackARuby < Gosu::Window

  def initialize 
    super(800, 600)
    self.caption = "Whack the Ruby!"
    @ruby_image = Gosu::Image.new('ruby.png')
    @hammer_image = Gosu::Image.new('hammer.png')
    @x = 200
    @y = 200
    @width = 50
    @height = 43
    @velocity_x = 5
    @velocity_y = 5
    @visible = 0 #ruby is visible if positive, invisible if negative
    @hit = 0
  end #END initiliaze METHOD

  def update #move objects, user actions
    @x += @velocity_x #allows the ruby image to appear to move
    @y += @velocity_y
    @velocity_x *= -1 if @x + @width/2 > 800 || @x - @width/2 < 0 #makes the ruby image "bounce" if it hits the edge of the screen
    @velocity_y *= -1 if @y + @height/2 > 600 || @y - @height/2 < 0
    @visible -= 1 #subtracts 1 from @visible
    @visible = 30 if @visible < -10 && rand < 0.01 #makes ruby visible for 30 frames if @visible 

  end #END update METHOD

  def draw
    if @visible > 0
      @ruby_image.draw(@x - @width / 2, @y - @width / 2, 1)
    end
    @hammer_image.draw(mouse_x - 40, mouse_y - 10, 1)
    if @hit == 0 #changes screen color based on whether you hit the ruby or not
      screen_color = Gosu::Color::NONE
    elsif @hit == 1
      screen_color = Gosu::Color::GREEN
    elsif @hit == -1
      screen_color = Gosu::Color::RED
    end
    draw_quad(0, 0, screen_color, 800, 0, screen_color, 800, 600, screen_color, 0, 600, screen_color)
    @hit = 0
  end #END draw METHOD

  def button_down(id)
    if (id == Gosu::MsLeft)
      if Gosu.distance(mouse_x, mouse_y, @x, @y) < 50 && @visible >= 0
        @hit = 1
      else
        @hit = -1
      end
    end
  end # END button_down METHOD

end # END WhackARuby CLASS

window = WhackARuby.new
window.show
