class AddLikeCountToTweet < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :like_count, :integer, default: 0
  end
end
