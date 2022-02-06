class ChangeThreadIdToTweetThreadId < ActiveRecord::Migration[7.0]
  def change
    rename_column :tweets, :thread_id, :tweet_thread_id
  end
end
