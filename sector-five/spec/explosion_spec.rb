require_relative '../explosion'

RSpec.describe Explosion do

  before(:example) do
    @window = double("window") # , :width => 800, :height => 600 a fake instance of "player" for testing purposes
    x = 200
    y = 400
    @explosion = Explosion.new(@window, x, y)
  end

  describe "default" do
    it "has a false value for @finished" do
      expect(@finished).to be_falsey
    end

    it "@image_index is 0" do
      expect(@image_index).to eql(0)
    end
  end

  describe "appearance" do
    it "increments the index count after the explosion runs" do
      starting_index = @image_index
      @explosion.draw
      expect(@image.index).to be > @image_index
    end
  end

end