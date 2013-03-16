require 'spec_helper'

describe "Signup Flow" do
  
  describe "signup page" do

    before { visit signup_path }

    it "should have the right page header" do
      page.should have_selector "h1", text: "Create an account"
    end

    it "should have the right form elements" do
      page.should have_selector "input", label: "Email"
      page.should have_selector "input", label: "Password"
      page.should have_button "Create account"
    end
  end

  describe "signing up" do

    before { visit signup_path }

    let(:submit) { "Create account" }

    describe "with invalid information" do

      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after failed signup attempt" do

        before { click_button submit }

        it "should display error messages" do
          page.should have_selector "li.error-message", text: "can't be blank"
        end
      end
    end

    describe "with valid information" do

      before do
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobarbaz"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after successful signup" do

        before { click_button submit }

        it "should redirect to the user profile page" do
          page.should have_content "user@example.com"
        end
      end
    end
  end
end
