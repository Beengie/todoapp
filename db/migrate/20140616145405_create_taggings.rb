class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.integer :todo_id
      t.integer :tag_id
      t.timestamps :t
    end
  end
end
