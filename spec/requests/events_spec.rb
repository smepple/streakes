require 'spec_helper'

describe "Events" do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:goal) { FactoryGirl.create(:goal, user: user) }
  let(:target) { FactoryGirl.create(:target, goal: goal) }
  let(:submit) { "Record event" }

  before do
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

  describe "new event page" do

    before do
      visit target_path(target)
      click_link "Record an event"
    end

    it "should display the right page title" do
      page.should have_selector "h1", text: "Record an event"
    end

    it "should have the right form fields" do
      page.should have_selector "input", label: "Description"
      page.should have_selector "input", label: "Completed on"
      page.should have_button submit
    end
  end

  describe "creating an event" do

    before do
      visit target_path(target)
      click_link "Record an event"
    end

    describe "with invalid information" do

      it "should not save the event" do
        expect { click_button submit }.not_to change(Event, :count)
      end

      describe "after an unsuccessful attempt to create an event" do

        before { click_button submit }

        it "should display error messages" do
          page.should have_selector ".error-message", text: "can't be blank"
        end
      end
    end

    describe "with valid information" do

      before do
        fill_in "Description", with: "Did some awesome shit"
        select Time.now.year.to_s, from: "event_completed_at_1i"
        select I18n.t("date.month_names")[Time.now.month], from: "event_completed_at_2i"
        select Time.now.day.to_s, from: "event_completed_at_3i"
      end

      it "should save the target" do
        expect { click_button submit }.to change(Event, :count).by(1)
      end
    end
  end

  describe "viewing events" do

    let(:event) { FactoryGirl.create(:event, target: target) }

    before { visit target_path(event.target) }

    describe "viewing all events for a target" do

      subject { page }

      it { should have_selector "h1", text: target.description }
      it { should have_link "Record an event" }
      it { should have_content event.description }
    end

    describe "viewing an individual event" do

      before { click_link event.description }

      it "should display the event description" do
        page.should have_selector "h1", text: event.description
      end

      it "should display the date the event was completed on" do
        page.should have_content "#{event.completed_at.strftime("%B")} #{event.completed_at.strftime("%e").to_i.ordinalize} #{event.completed_at.strftime(", %Y")}"
      end

      it "should display the event's target" do
        page.should have_selector "h3", text: event.target.description
      end

      it "should display the goal the event's target relates to" do
        page.should have_selector "h3", text: event.target.goal.description
      end

      it "should display a link to delete the event" do
        page.should have_link "Delete event"
      end
    end
  end

  describe "deleting an event" do

    let(:event_owner) { FactoryGirl.create(:user) }
    let(:goal) { FactoryGirl.create(:goal, user: event_owner) }
    let(:target) { FactoryGirl.create(:target, goal: goal) }
    let(:event) { FactoryGirl.create(:event, target: target) }

    describe "as the wrong user" do

      before { visit event_path(event) }

      specify "page should not display the delete button" do
        page.should_not have_link "Delete event"
      end
    end

    describe "as the right user" do

      let(:delete) { "Delete event" }

      before do
        visit signin_path
        fill_in "Email", with: event_owner.email
        fill_in "Password", with: event_owner.password
        click_button "Sign in"
        visit event_path(event)
      end

      it "should delete the event" do
        expect { click_link delete }.to change(Event, :count).by(-1)
      end

      describe "after successfully deleting an event" do

        before { click_link delete }

        specify "user should be taken to the target details page" do
          page.should have_selector "h1", text: event.target.description
          page.should_not have_content event.description
        end

        specify "a success message should be displayed" do
          page.should have_selector ".flash-success", text: "deleted"
        end
      end
    end
  end
end
