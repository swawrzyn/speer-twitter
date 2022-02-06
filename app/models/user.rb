# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_username  (username) UNIQUE
#

class User < ApplicationRecord
  has_secure_password
  validates :username, presence: true, uniqueness: true, length: { minimum: 4, maximum: 16 }
  validate :password_complexity

#   attr_accessor :id, :username

  def password_complexity
    if password.blank? ||
         password =~
           /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,64}$/
      return
    end

    errors.add :password,
               'Password should be between 8-64 characters and include 1 uppercase, 1 lowercase, 1 digit and 1 special character.'
  end
end
