require 'spec_helper'
include OwnTestHelper

describe "User page" do
  let!(:brewery) { FactoryGirl.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name: "iso 3", brewery: brewery }
  let!(:beer2) { FactoryGirl.create :beer, name: "Karhu", brewery: brewery }
  let!(:user) { FactoryGirl.create :user }
  let!(:user2) { FactoryGirl.create :user2 }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
    FactoryGirl.create :rating, beer_id: beer1.id, score: 24, user: user
    FactoryGirl.create :rating, beer_id: beer2.id, score: 21, user: user
    FactoryGirl.create :rating, beer_id: beer2.id, score: 23, user: user2
  end

  it "shows all ratings made by that user and none of others" do

    @ratings = Rating.all

    visit user_path(user)

    @ratings.each do |rating|
      expected_content = rating.beer.name + " " + rating.score.to_s
      if rating.user == user
        expect(page).to have_content expected_content
      else
        expect(page).to_not have_content expected_content
      end
    end
    save_and_open_page
  end
end