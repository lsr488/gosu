require 'gosu'

class WhackARuby < Gosu::Window
attr_accessor :sorted_high_scores

  def initialize 
    super(800, 600)
    self.caption = "Whack the Ruby!"
    @ruby_image = Gosu::Image.new('ruby.png')
    @hammer_image = Gosu::Image.new('hammer.png')
    @x = 200
    @y = 200
    @width = 50
    @height = 43
    @velocity_x = 4
    @velocity_y = 4
    @visible = 0 #ruby is visible if positive, invisible if negative
    @hit = 0 #tracks whether you hit the ruby or not
    @font = Gosu::Font.new(30) #writes text on screen, eg for keeping score
    @playing = true
    @start_time = 0
    @game_duration = 30
    @score = 0
    @for_score_records = 0
    @high_scores = []
    @sorted_high_scores = []    
  end #END initiliaze METHOD

  def update #move objects, user actions
    if @playing
      @x += @velocity_x #allows the ruby image to appear to move
      @y += @velocity_y
      @velocity_x *= -1 if @x + @width/2 > 800 || @x - @width/2 < 0 #makes the ruby image "bounce" if it hits the edge of the screen
      @velocity_y *= -1 if @y + @height/2 > 600 || @y - @height/2 < 0
      @visible -= 1 #subtracts 1 from @visible
      @visible = 30 if @visible < -10 && rand < 0.01 #makes ruby visible for 30 frames if @visible 
      @time_left = (@game_duration - ((Gosu.milliseconds - @start_time)/1000))
      if @time_left < 0
        update_score
        sort_score
        @playing = false
      end
    end
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
    @font.draw(@score.to_s, 700, 20, 2)
    @font.draw(@time_left.to_s, 20, 20, 2)
    unless @playing
      @font.draw("Game Over", 300, 200, 3) #x, y, ??
      @font.draw("Press Space Bar to Play Again", 175, 250, 3)
      @font.draw("HIGH SCORES: #{@sorted_high_scores.first(5).join(', ')}", 175, 300, 3)
      @visible = 20
    end
  end #END draw METHOD

  def button_down(id)
    if @playing
      if (id == Gosu::MsLeft)
        if Gosu.distance(mouse_x, mouse_y, @x, @y) < 50 && @visible >= 0
          @hit = 1
          @score += 5
        else
          @hit = -1
          @score -= 1
        end
      end
    else
      if (id == Gosu::KbSpace) #press spacebar to continue, resets values
        @playing = true
        @visible = -10
        @start_time = Gosu.milliseconds
        @score = 0
      end
    end
  end # END button_down METHOD

  def update_score 
    @for_score_records = @score
    filename = "scores.txt"
    File.open(filename, 'a+') do |file|
      file.write(@for_score_records)
      file.write "\n"
    end
  end

  def sort_score
    filename = "scores.txt"
    File.open(filename, 'a+').each_line do |line|
      @high_scores << line.chomp.to_i
    end
    
    @high_scores.each do |num|
      num.to_s.rjust(2,'0')
    end

    @sorted_high_scores = @high_scores.sort.reverse
    
  end

end # END WhackARuby CLASS

window = WhackARuby.new
window.show
