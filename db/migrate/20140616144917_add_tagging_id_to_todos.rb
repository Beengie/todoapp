class AddTaggingIdToTodos < ActiveRecord::Migration
  def change
    add_column :todos, :tagging_id, :integer
  end
end
