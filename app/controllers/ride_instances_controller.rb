class RideInstancesController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @is_rider = @event.is_rider?(current_user.id)
    if @is_rider
      @open_drivers = @event.free_driver_instances
      @instance = @event.get_rider_id(current_user.id)
      if @event.has_ride?(current_user.id)
        @riders_driver = get_driver_of(current_user.id)
      end
    else
      @free_riders = @event.free_riders
      @current_riders = @event.riders_for_driver(current_user.id)
    end
  end

  def new
    @event = Event.find(params[:event_id])
    if @event.not_attending?(current_user.id)
      @instance = RideInstance.new
    else
      redirect_to event_ride_instances_path(@event)
    end
  end

  def edit
  end

  def show
  end

  def create
    #test this
    @user = current_user
    type = params[:instance][:type]
    @event = Event.find(params[:event_id])
    @instance = RideInstance.new
    if type.to_i == 1 
      @instance.pickup_location = params[:instance][:pickup]
      @instance.pickup_capacity = params[:instance][:capacity]
      @instance.pickup_time = params[:instance][:pickup_time]
    end
    
    @instance.event = @event
    @instance.rider = @user if type.to_i == 0 #user wants to be a rider
    @instance.driver = @user if type.to_i == 1 #user wants to be a driver
    if @instance.save
      redirect_to event_ride_instances_path(@event)
    end
  end
end
