class RideInstancesController < ApplicationController
  def index
  end

  def new
    @event = Event.find(params[:event_id])
    if @event.not_attending?(current_user.id)
      @instance = RideInstance.new
    else
      redirect_to event_ride_instances_index_path(@event)
    end
  end

  def edit
  end

  def show
  end

  def create
    raise 'error'
    @user = current_user
    type = params[:instance][:type]
    @event = Event.find(params[:event_id])
    @instance = EventInstance.new
    @instance.event = event
    @instance.rider = user if type == 0 #user wants to be a rider
    @instance.driver = user if type == 1 #user wants to be a driver
    if @instance.save
      redirect_to event_ride_instance_path(@event, @instance)
    end
  end
end
