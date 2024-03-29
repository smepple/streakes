require 'spec_helper'

describe "Static pages" do
  
  describe "Home page" do

    before { visit root_path }

    it "should display the app name" do
      page.should have_content "Streakes"
    end

    it "should have a link to get started" do
      page.should have_link "Get started"
    end

    it "should have a link to sign in" do
      page.should have_selector 'a', class: "sign-in"
    end
  end
end
