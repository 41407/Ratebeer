require 'spec_helper'

describe "Places" do
  before :each do
    BeermappingApi.stub(:places_in).with("kumpula").and_return(
        [Place.new(:name => "Oljenkorsi")]
    )
    BeermappingApi.stub(:places_in).with("Kannelmäki").and_return(
        [Place.new(:name => "Britannia"), Place.new(:name => "William K.")]
    )
    BeermappingApi.stub(:places_in).with("otaniemi").and_return(
        []
    )
  end

  it "if one is returned by the API, it is shown at the page" do
    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple are returned by API, all of those are shown at the page" do
    visit places_path
    fill_in('city', with: 'Kannelmäki')
    click_button "Search"
    expect(page).to have_content "Britannia"
    expect(page).to have_content "William K."
  end

  it "if no places for city is found, displays appropriate message" do
    visit places_path
    city = 'otaniemi'
    fill_in('city', with: city)
    click_button "Search"
    expect(page).to have_content ("No locations in " << city)

  end
end