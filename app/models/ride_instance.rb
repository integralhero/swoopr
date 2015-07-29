class RideInstance < ActiveRecord::Base
  belongs_to :event
  belongs_to :rider, :foreign_key => "rider_id", :class_name => "User"
  belongs_to :driver, :foreign_key => "driver_id", :class_name => "User"


end
