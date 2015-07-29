class Event < ActiveRecord::Base
	has_many :ride_instances
	has_many :riders, :through => :ride_instances
	belongs_to :owner, foreign_key: "owner_id", class_name: "User"

	def free_riders
		ride_instances.where(driver_id: nil)
	end

	def not_attending?(user_id)
		driver = ride_instances.where(driver_id: user_id)
		rider = ride_instances.where(rider_id: user_id)
		return driver.size == 0 && rider.size == 0
	end
end
