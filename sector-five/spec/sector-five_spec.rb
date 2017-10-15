require_relative '../sector-five'

RSpec.describe SectorFive do
 
 before(:example) do
    @window = double("window", :width => 800, :height => 600) # a fake instance of "player" for testing purposes
    @player = Player.new(@window)
  end

  describe "defaults" do
    it "has empty array of enemies" do
      expect(@enemies).to be_falsey
    end

    it "has empty array of bullets" do
      expect(@bullets).to be_falsey
    end

    it "has empty array of explosions" do
      expect(@explosions).to be_falsey
    end
  end

  describe "player ship controls" do
    it "turns left on left arrow click" do
    end

    it "turns right on right arrow click" do
    end

    it "accelerates on up arrow click" do
    end


  end

  # Google how to test Gosu draw function
end
