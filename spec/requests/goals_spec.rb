require 'spec_helper'

describe "Goals" do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:submit) { "Add goal" }

  before do
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

  describe "new goal page" do

    before { visit new_goal_path }

    it "should display the right page title" do
      page.should have_selector "h1", text: "Add a goal"
    end

    it "should have the right form fields" do
      page.should have_selector "input", label: "Description"
      page.should have_button submit
    end
  end

  describe "creating a goal" do

    before { visit new_goal_path }

    describe "with invalid information" do

      it "should not save the goal" do
        expect { click_button submit }.not_to change(Goal, :count)
      end

      describe "after an unsuccesful attempt to create a goal" do

        before { click_button submit }

        it "should display error messages" do
          page.should have_selector ".error-message", text: "can't be blank"
        end
      end
    end

    describe "with valid information" do

      before { fill_in "Description", with: "Get shit done!" }

      it "should save the goal" do
        expect { click_button submit }.to change(Goal, :count).by(1)
      end
    end
  end

  describe "viewing goals" do

    let(:goal) { FactoryGirl.create(:goal, user: user) }

    before { visit user_path(goal.user) }

    describe "viewing all goals for a user" do

      subject { page }

      it { should have_selector "h1", text: "Goals" }
      it { should have_link "Add a goal" }
      it { should have_content goal.description }
    end

    describe "viewing an individual goal" do

      before { click_link goal.description }

      it "should display the goal description" do
        page.should have_selector "h1", text: goal.description
      end

      it "should display option to add a target" do
        page.should have_link "Add a target"
      end

      it "should display a link to delete the goal" do
        page.should have_link "Delete goal"
      end
    end
  end

  describe "deleting a goal" do

    let(:goal_owner) { FactoryGirl.create(:user) }
    let(:goal) { FactoryGirl.create(:goal, user: goal_owner) }

    describe "as the wrong user" do

      before { visit goal_path(goal) }

      specify "page should not display delete button" do
        page.should_not have_link "Delete goal"
      end
    end

    describe "as the right user" do

      before do
        visit signin_path
        fill_in "Email", with: goal_owner.email
        fill_in "Password", with: goal_owner.password
        click_button "Sign in"
        visit goal_path(goal)
      end

      it "should delete the goal" do
        expect { click_link "Delete goal" }.to change(Goal, :count).by(-1)
      end

      describe "after successfully deleting a goal" do

        before { click_link "Delete goal" }

        specify "user should be taken to the user profile page" do
          page.should have_selector "h1", text: "Goals"
          page.should_not have_content goal.description
        end

        specify "a success message should be displayed" do
          page.should have_selector ".flash-success", text: "deleted"
        end
      end
    end
  end
end
