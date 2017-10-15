require_relative '../sector-five-scenes'

RSpec.describe SectorFive do
 
 before(:example) do
    @window = double("window", :width => 800, :height => 600) # a fake instance of "player" for testing purposes
    @player = Player.new(@window)
  end

  describe "scenes defaults" do
    it "has empty array of enemies" do
      expect(@enemies).to be_falsey
    end

    it "has empty array of bullets" do
      expect(@bullets).to be_falsey
    end

    it "has empty array of explosions" do
      expect(@explosions).to be_falsey
    end

    it "creates an instance of Player" do
      expect(Player.new(@window)).to be_an_instance_of Player
    end    
  end

  # I don't think this is actually testing the methods I think it's testing...
  # is it testing .update_game or .button_down_game? 
  describe ".update_game" do
    it "fires a bullet on spacebar press" do
      game_window = SectorFive.new
      space_bar = Gosu::KbSpace
      expect_any_instance_of(SectorFive).to receive(:fire)
      game_window.button_down_game(space_bar)
    end

    it "turns left on left arrow click" do
      game_window = SectorFive.new
      game_window.button_down_game(Gosu::KbLeft)
      expect(@player).to receive(:turn_left)
    end

    it "turns right on right arrow click" do
    end

    it "accelerates on up arrow click" do
    end
  end

  # Google how to test Gosu draw function
end
