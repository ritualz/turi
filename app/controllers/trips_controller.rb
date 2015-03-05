class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def show
    authorize @trip
    @tags = @trip.tag_counts_on(:tags)
    render layout: 'trip'
  end

  def index
    @trips =  Trip.all
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.create(trip_params)

    # TODO: remove this relation.
    @trip.user = current_user

    if @trip.save
      @trip.participants.create(participant_role_id: ParticipantRole.owner.id, user_id: current_user.id)
      @trip.tag_list.add(trip_params[:tag_list], parse: true)
      flash[:notice] = I18n.t 'trip_created'
      redirect_to @trip
    else
      flash[:alert] = I18n.t 'trip_not_created'
      render :new
    end
  end

  def search
    @user, @trips = Trip.search(params[:title_search], params[:location_search], params[:tag_search], params[:date_beg], params[:date_end], params[:name_search])
  end

  def update
    authorize @trip
    if @trip.update(trip_params)
      @trip.tag_list.remove(@trip.tag_list, parse: true)
      @trip.tag_list.add(trip_params[:tag_list], parse: true)
      flash[:notice] = I18n.t 'trip_updated'
      redirect_to @trip
    else
      flash[:alert] = I18n.t 'trip_not_updated'
      render 'edit'
    end
  end

  def edit
    authorize @trip, :update?
    render layout: 'trip'
  end

  def destroy
    authorize @trip

    @trip.destroy
    flash[:notice] = I18n.t 'trip_deleted'

    redirect_to dashboard_path
  end

  private
  def trip_params
    params.require(:trip).permit(:title, :description, :start_loc, :start_date, :end_loc, :end_date, :image, :tag_list)
  end

  def set_trip
    @trip = Trip.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = I18n.t 'trip_not_found'
    redirect_to dashboard_path
  end

end
