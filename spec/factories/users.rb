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

FactoryBot.define do
  factory :user do
    sequence :username do |n|
      "user##{n}"
    end
    password { "Password123!" }
  end
end
