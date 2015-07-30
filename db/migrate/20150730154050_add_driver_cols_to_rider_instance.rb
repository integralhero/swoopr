class AddDriverColsToRiderInstance < ActiveRecord::Migration
  def change
  	add_column :ride_instances, :pickup_time, :time 
  	add_column :ride_instances, :pickup_location, :string
  	add_column :ride_instances, :pickup_capacity, :integer
  end
end
