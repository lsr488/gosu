require_relative '../player'

RSpec.describe Player do

  before(:example) do
    @window = double("window", :width => 800, :height => 600) # a fake instance of "player" for testing purposes
    @player = Player.new(@window)
  end

  describe "defaults" do
    it "has an x position" do
      expect(@player.x).to eql(200)
    end

    it "has a y position" do
      expect(@player.y).to eql(400)
    end

    it "has an angle position" do
      expect(@player.angle).to eql(0)
    end  

    it "has a radius value" do
      expect(@player.radius).to eql(20)
    end
  end

  describe "movement" do
    it "turns the ship to the left" do
      starting_angle = @player.angle
      @player.turn_left
      expect(@player.angle).to be < starting_angle
    end

    it "turns the ship to the right" do
      starting_angle = @player.angle
      @player.turn_right
      expect(@player.angle).to be > starting_angle
    end

    it "doesn't move ship unless also accelerating" do
      starting_x = @player.x
      starting_y = @player.y
      @player.move
      expect(@player.x).to eql(starting_x)
      expect(@player.y).to eql(starting_y)
    end

    it "moves the ship while also accelerating" do
      starting_x = @player.x
      starting_y = @player.y

      @player.accelerate
      @player.move

      expect(@player.x).not_to eql(starting_x)
      expect(@player.y).not_to eql(starting_y)
    end

    it "bounces off right edge of screen" do
      player = Player.new(@window, @window.width, 100)
      expect(player.x).to eql(@window.width)

      player.turn_right
      player.accelerate
      player.move

      expect(player.x).to be < @window.width
    end

    it "bounces off left edge of screen" do
      player = Player.new(@window, 0, 100)
      expect(player.x).to eql(0)

      player.turn_left
      player.accelerate
      player.move

      expect(player.x).to be > 0
    end

    it "bounces off bottom edge of screen" do
      player = Player.new(@window, 100, @window.height)
      expect(player.y).to eql(@window.height)

      while (player.angle != 180)
        player.turn_right
      end
      player.accelerate
      player.move

      expect(player.y).to be < @window.height
    end 

  end

  # this is potentially difficult to test? Google how to test Gosu.
  # it "displays a sprite on the window" do
  # end

end