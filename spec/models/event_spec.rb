# == Schema Information
#
# Table name: events
#
#  id           :integer          not null, primary key
#  target_id    :integer
#  description  :string(255)
#  completed_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Event do
  
  let(:event) { FactoryGirl.create(:event) }

  subject { event }

  it { should respond_to :target_id }
  it { should respond_to :target }
  it { should respond_to :description }
  it { should respond_to :completed_at }

  it { should be_valid }

  describe "when target_id is not present" do
    before { event.target_id = nil }
    it { should_not be_valid }
  end

  describe "when description is not present" do
    before { event.description = "" }
    it { should_not be_valid }
  end

  describe "when completed_at is not present" do
    before { event.completed_at = nil }
    it { should_not be_valid }
  end
end
