require_relative '../player'

RSpec.describe Player do
  before(:example) do
    window = double("window") # a fake instance of "player" for testing purposes
    @player = Player.new(window)
  end

  it "has an image sprite" do
    expect(@image).to have_content 'images/ship.png' 
  end

  it "has an x position" do
    expect(@x).to eql(200)
  end

  it "has a y position" do
    expect(@y).to eql(200)
  end

  it "has an angle position" do
    expect(@angle).to eql(0)
  end  

  it "turns the ship left" do
    expect(@player.turn_right).to 
  end

end