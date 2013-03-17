# == Schema Information
#
# Table name: goals
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Goal do
  
  let(:goal) { FactoryGirl.create(:goal) }

  subject { goal }

  it { should respond_to :user_id }
  it { should respond_to :user }
  it { should respond_to :description }

  it { should be_valid }

  describe "when user_id is not present" do
    before { goal.user_id = nil }
    it { should_not be_valid }
  end

  describe "when description is not present" do
    before { goal.description = "" }
    it { should_not be_valid }
  end
end
