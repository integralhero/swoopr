class CreateRideInstances < ActiveRecord::Migration
  def change
    create_table :ride_instances do |t|
      t.references :event, index: true, foreign_key: true
      t.integer :rider_id, index: true, foreign_key: true
      t.integer :driver_id, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
