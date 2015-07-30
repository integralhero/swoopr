class EventsController < ApplicationController
  def new
  	@event = Event.new
  end

  def index
  	@events = Event.all
  end

  def update
    @event = Event.find(params[:id])
    if params["action_taken"] == "rider_add_driver"
      @event.add_ride(params[:driver_id].to_i, current_user.id)
    elsif params["action_taken"] == "rider_leave_driver"
      @event.remove_ride(params[:driver_id].to_i, current_user.id)
    elsif params["action_taken"] == "driver_remove_rider"
      @event.remove_ride(current_user.id, params[:rider_id].to_i)
    elsif params["action_taken"] == "driver_quits"
      @event.delete_driver(current_user.id)
      redirect_to new_event_ride_instance_path(@event)
    elsif params["action_taken"] == "rider_quits" 
      @event.delete_rider(current_user.id) 
      redirect_to new_event_ride_instance_path(@event)
    end
    redirect_to :back
  end

  def create
  	@e = Event.new
    @e.location = event_params[:location]
    @e.name = event_params[:name]
    @e.owner_id = current_user.id
    @e.time = event_params[:time]
    @e.save
		redirect_to event_path(@e)
  end

  def edit
  	
  end

  def show
  	@event = Event.find(params[:id])
  end

  private
  	def event_params
  		params.require(:event).permit(:location, :time, :name)
  	end
end
