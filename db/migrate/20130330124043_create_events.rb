class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :target_id
      t.string :description
      t.datetime :completed_at

      t.timestamps
    end
  end
end
