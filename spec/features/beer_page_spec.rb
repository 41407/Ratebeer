require 'spec_helper'

describe "Beer creation page" do
  let!(:user) { FactoryGirl.create :user }
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "creates beer if given name is valid" do
    visit new_beer_path
    fill_in('beer_name', with: 'Koira')
    expect{
      click_button 'Create Beer'
    }.to change{Beer.count}.by(1)
  end

  it "if name is invalid, doesn't create new beer and shows error message" do
    visit new_beer_path
    expect{
      click_button 'Create Beer'
    }.to change{Beer.count}.by(0)
    expect(page).to have_content "Name can't be blank"
  end
end