class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :tag
      t.timestamps :t
    end
  end
end
