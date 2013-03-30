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

class Event < ActiveRecord::Base
  attr_accessible :completed_at, :description, :target_id

  belongs_to :target

  validates_presence_of :target_id, :description, :completed_at

  default_scope order("completed_at ASC, created_at ASC")
end
