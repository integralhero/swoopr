class Event < ActiveRecord::Base
	has_many :ride_instances
	has_many :riders, :through => :ride_instances
	has_many :drivers, :through => :ride_instances
	belongs_to :owner, foreign_key: "owner_id", class_name: "User"
	accepts_nested_attributes_for :ride_instances

	def get_driver_of(rider_id)
		ride_instances.where(rider_id: rider_id, driver_id: [nil, -1]).first
	end
	def get_driver(driver_id)
		ride_instances.where(driver_id: driver_id, rider_id: nil).first
	end
	def get_rider_id(rider_id)
		ride_instances.where(rider_id: rider_id).first
	end
	def riders_for_driver(driver_id)
		return ride_instances.where(driver_id: driver_id).where.not(rider_id: [nil, -1]).map{|r| r.rider}
	end

	def is_rider?(user_id)
		return get_rider_id(user_id) != nil
	end
	# 'free' drivers have rider_id == nil
	# 'free' riders have driver_id == nil

	def free_riders
		ride_instances.where(driver_id: nil).map{|r| r.rider}
	end

	def free_rider_instances
		ride_instances.where(driver_id: nil)
	end

	def free_drivers
		ride_instances.where(rider_id: nil).map{|r| r.driver}
	end

	def free_driver_instances
		ride_instances.where(rider_id: nil)
	end

	def add_ride(driver_id, rider_id)
		r = get_rider_id(rider_id)
		d = get_driver(driver_id)
		cur_num_riders = riders_for_driver(driver_id).size
		cap = d.pickup_capacity
		if cur_num_riders + 1 <= cap
			r.driver_id = driver_id if r.driver_id == nil
			d.rider_id = -1 if cap == cur_num_riders + 1
			r.save
			d.save
		end
	end

	
	def remove_ride(driver_id, rider_id) #kick or leave car
		r = get_rider_id(rider_id)
		d = get_driver(driver_id)
		r.driver_id = nil  #rider becomes free
		d.rider_id = nil #always set to nil
		r.save
		d.save
	end

	def delete_rider(rider_id) #doesn't want to be a rider
		r = get_rider_id(rider_id) #rider_id is unique to event
		r.delete
	end

	def delete_driver(driver_id) #doesn't want to a driver
		rides_inst = riders_for_driver(driver_id)
		rides_inst.each do |r|
			remove_ride(driver_id, r.rider_id) #move each rider out of driver's car
		end
		d = get_driver(driver_id)
		d.delete if d != nil #remove driver instance
	end

	def has_ride?(rider_id)
		rides = ride_instances.where(rider_id: rider_id)
		return rides.any?{|r| r.driver_id != nil}
	end

	def not_attending?(user_id)
		driver = ride_instances.where(driver_id: user_id)
		rider = ride_instances.where(rider_id: user_id)
		return driver.size == 0 && rider.size == 0
	end
end
