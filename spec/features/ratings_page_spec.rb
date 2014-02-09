require 'spec_helper'
include OwnTestHelper

describe "Ratings page" do
  let!(:brewery) { FactoryGirl.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name: "iso 3", brewery: brewery }
  let!(:beer2) { FactoryGirl.create :beer, name: "Karhu", brewery: brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "shows all ratings in database, and their total number" do
    beer = FactoryGirl.create :beer, name: "Hoegaarden", brewery: brewery
    FactoryGirl.create :rating, beer_id: beer.id, score: 20, user: user
    FactoryGirl.create :rating, beer_id: beer1.id, score: 24, user: user
    FactoryGirl.create :rating, beer_id: beer2.id, score: 21, user: user

    @ratings = Rating.all

    visit ratings_url

    expect(page).to have_content "Number of ratings: #{@ratings.count}"
    @ratings.each do |rating|
      expected_content = rating.beer.name + " " + rating.score.to_s + " " + rating.user.username
      expect(page).to have_content expected_content
    end


    save_and_open_page
  end
end