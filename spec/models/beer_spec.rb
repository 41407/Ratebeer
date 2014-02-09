require 'spec_helper'

describe Beer do
  it "is saved if name and style are set" do
    beer = Beer.create name:"Testiolut", style: "Lager"

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)

  end
  describe "is not created if" do
    it "name is undefined" do
      beer = Beer.create style: "Lager"

      expect(beer).not_to be_valid
    end
    it "style is undefined" do
      beer = Beer.create name: "Testiolut"

      expect(beer).not_to be_valid
    end
  end
end
