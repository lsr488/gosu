require_relative '../bullet'

RSpec.describe Bullet do

  before(:example) do
    @window = double("window") # , :width => 800, :height => 600 a fake instance of "player" for testing purposes
    @player = Player.new(@window)
    @bullets = []
  end

  # these probably require testing Gosu's draw function. Google it.
  # need some way to populate the bullet array with dummy bullets (??)
  # then I can test @bullets.each do |bullet| for their default values
  describe "default" do
    it "has an x position" do
      expect(@bullets.x).to eql(@player.x)
    end

    it "has a y position" do
      expect(bullet.y).to eql(@player.y)
    end

    it "has a radius value" do
      expect(bullet.radius).to eql(3)
    end

    it "has direction based on Player's angle" do
      expect(bullet.direction).to eql(@player.angle)
    end
  end

  describe "movement" do
    it "moves along the X axis" do
      starting_x = bullet.x
      @bullets.each do |bullet|
        bullet.move
      end
      expect(bullet.x).to be > starting_x
    end

    it "moves along the Y axis" do
    end
  end

end