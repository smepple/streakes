require 'spec_helper'

describe "Targets" do

  let(:user) { FactoryGirl.create(:user) }
  let(:goal) { FactoryGirl.create(:goal, user: user) }
  let(:submit) { "Add target" }
  
  before do
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

  describe "new target page" do

    before do
      visit goal_path(goal)
      click_link "Add a target"
    end

    it "should display the right page title" do
      page.should have_selector "h1", text: "Add a target"
    end

    it "should have the right form fields" do
      page.should have_selector "input", label: "Description"
      page.should have_button submit
    end
  end

  describe "creating a target" do

    before do
      visit goal_path(goal)
      click_link "Add a target"
    end

    describe "with invalid information" do

      it "should not save the target" do
        expect { click_button submit }.not_to change(Target, :count)
      end

      describe "after an unsuccesful attempt to create a target" do

        before { click_button submit }

        it "should display error messages" do
          page.should have_selector ".error-message", text: "can't be blank"
        end
      end
    end

    describe "with valid information" do

      before { fill_in "Description", with: "Do shit twice a week" }

      it "should save the target" do
        expect { click_button submit }.to change(Target, :count).by(1)
      end
    end
  end

  describe "viewing targets" do

    let(:target) { FactoryGirl.create(:target, goal: goal) }

    before { visit goal_path(target.goal) }

    describe "viewing all targets for a goal" do

      subject { page }

      it { should have_selector "h1", text: goal.description }
      it { should have_link "Add a target" }
      it { should have_content target.description }
    end

    describe "viewing an individual target" do

      before { click_link target.description }

      it "should display the target description" do
        page.should have_selector "h1", text: target.description
      end

      it "should display the target's goal" do
        page.should have_selector "h3", text: target.goal.description
      end

      it "should display a link to delete the target" do
        page.should have_link "Delete target"
      end
    end
  end

  describe "deleting a target" do

    let(:target_owner) { FactoryGirl.create(:user) }
    let(:goal) { FactoryGirl.create(:goal, user: target_owner) }
    let(:target) { FactoryGirl.create(:target, goal: goal) }

    describe "as the wrong user" do

      before { visit target_path(target) }

      specify "page should not display the delete button" do
        page.should_not have_link "Delete target"
      end
    end

    describe "as the right user" do

      before do
        visit signin_path
        fill_in "Email", with: target_owner.email
        fill_in "Password", with: target_owner.password
        click_button "Sign in"
        visit target_path(target)
      end

      it "should delete the target" do
        expect { click_link "Delete target" }.to change(Target, :count).by(-1)
      end

      describe "after successfully deleting a target" do

        before { click_link "Delete target" }

        specify "user should be taken to the goal details page" do
          page.should have_selector "h1", text: target.goal.description
          page.should_not have_content target.description
        end
        
        specify "a success message should be displayed" do
          page.should have_selector ".flash-success", text: "deleted"
        end
      end
    end
  end
end
