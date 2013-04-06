require 'spec_helper'

describe "Authentication" do

  describe "signin page" do

    before { visit signin_path }

    it "should have the right page header" do
      page.should have_selector "h1", text: "Sign in"
    end

    it "should have the right form elements" do
      page.should have_selector "input", label: "Email"
      page.should have_selector "input", label: "Password"
      page.should have_button "Sign in"
    end
  end
  
  describe "signing in" do

    before { visit signin_path }

    describe "with invalid information" do

      before { click_button "Sign in" }

      describe "after an unsuccessful signin attempt" do

        specify "user should remain on the signin page" do
          page.should have_selector "h1", text: "Sign in"
        end

        it "should display error messages" do
          page.should have_selector ".flash-error", text: "Invalid"
        end
      end
    end

    describe "with valid information" do

      let(:user) { FactoryGirl.create(:user) }

      before do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      describe "after successfully signing in" do

        specify "user should be taken to the user profile page" do
          page.should have_link user.email
        end

        specify "signout link should be displayed in the header" do
          page.should have_link "Sign out"
        end
      end
    end
  end

  describe "signing out" do

    let(:user) { FactoryGirl.create(:user) }

    before do
      visit signin_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Sign in"
      click_link "Sign out"
    end

    describe "after signing out" do

      specify "user should be taken to the home page" do
        page.should have_selector "h1.logo", text: "Streakes"
        page.should have_link "Get started"
      end

      describe "visiting another page" do

        before { visit signup_path }

        specify "signin link should be displayed in the header" do
          page.should have_link "Sign in"
        end
      end
    end
  end
end
