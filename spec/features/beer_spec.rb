require 'spec_helper'

describe "Beer" do

  describe "creation page" do

    it "adds beer with valid name" do
      visit new_beer_path
      fill_in('beer_name', with: 'Koira')

      click_button "Create Beer"

      save_and_open_page
    end
  end
end