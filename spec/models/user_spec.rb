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

require 'rails_helper'

RSpec.describe User, type: :model do
  context "validations" do
    it "ensures presence of username" do
      user = User.new(username: "", password: 'Testing123!!').save

      expect(user).to eq(false)
    end

    it "ensures presence of password" do
      user = User.new(username: "Testing123!", password: '')

      user.validate

      expect(user.errors[:password]).to include("can't be blank")
    end

    it "ensures complex password" do
      user = User.new(username: "Testing123!", password: "abc")

      expect(user).to_not be_valid

      user.password = "abcd1234"

      expect(user).to_not be_valid

      user.password = "Abcd1234"

      expect(user).to_not be_valid

      user.password = "Abcd123!"

      expect(user).to be_valid
    end

    it "ensures minimum length of username" do
      user = User.new(username: "abc", password: "Testing123!")

      user.validate

      expect(user.errors[:username]).to include("is too short (minimum is 4 characters)")
    end

    it "ensures username uniqueness" do
      user = User.create!(username: "abcd", password: "Testing123!")
      user2 = User.new(username: "abcd", password: "Testing123!")

      user2.validate
      puts "messages:", user.username, user2.username
      expect(user2.errors[:username]).to include("has already been taken")
    end
  end
end
