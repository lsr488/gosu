require_relative '../sector-five'

RSpec.describe SectorFive do
  before(:each) do
    @window = SectorFive.new
  end

  it "opens a new window" do
    expect(@window.caption).to eql("Sector Five")
  end

  it "creates a new Player" do
    expect(@player).to exist
  end

end
