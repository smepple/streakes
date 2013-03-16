# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  remember_token  :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :password

  has_secure_password

  before_save { email.downcase! }
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, with: VALID_EMAIL_REGEX

  validates_length_of :password, minimum: 8

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
