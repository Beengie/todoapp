class CreateTodosTable < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :name
      t.string :description
      t.timestamps :t
    end
  end
end
