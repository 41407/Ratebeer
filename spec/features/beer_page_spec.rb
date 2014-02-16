require 'spec_helper'
require 'support/own_test_helper'

describe "Beer" do
  let!(:brewery) { FactoryGirl.create :brewery, name: "Koff" }
  let!(:style) { FactoryGirl.create :style, name: "whateveer"}

  before :each do
    FactoryGirl.create :user
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "is created when given a valid name" do
    visit new_beer_path
    fill_in('beer_name', with: 'Arrogant Bastard Ale')
    expect {
      click_button('Create Beer')
    }.to change { Beer.count }.by(1)
  end

  it "is not created with invalid name" do
    visit new_beer_path

    expect {
      click_button('Create Beer')
    }.to change { Beer.count }.by(0)
    expect(page).to have_content "Name can't be blank"
    expect(page).to have_content "New beer"
  end
end