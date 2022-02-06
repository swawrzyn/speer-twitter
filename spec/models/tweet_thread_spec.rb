# == Schema Information
#
# Table name: tweet_threads
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tweet_threads_on_user_id  (user_id)
#

# require 'rails_helper'

# RSpec.describe TweetThread, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
