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

class Target < ActiveRecord::Base
  attr_accessible :goal_id, :description

  belongs_to :goal
  has_many :events, dependent: :destroy

  validates_presence_of :goal_id, :description
end
