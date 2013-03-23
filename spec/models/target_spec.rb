# == Schema Information
#
# Table name: targets
#
#  id          :integer          not null, primary key
#  goal_id     :integer
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Target do
  
  let(:target) { FactoryGirl.create(:target) }

  subject { target }

  it { should respond_to :goal_id }
  it { should respond_to :description }
  it { should respond_to :goal }

  it { should be_valid }

  describe "when goal_id is not present" do
    before { target.goal_id = nil }
    it { should_not be_valid }
  end

  describe "when description is not present" do
    before { target.description = "" }
    it { should_not be_valid }
  end
end
