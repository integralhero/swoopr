class ChangeRideInstanceTimeToDt < ActiveRecord::Migration
  def change
  	change_column :ride_instances, :pickup_time, :datetime
  end
end
