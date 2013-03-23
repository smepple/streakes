class CreateTargets < ActiveRecord::Migration
  def change
    create_table :targets do |t|
      t.integer :goal_id
      t.string :description

      t.timestamps
    end
  end
end
