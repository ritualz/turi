class UsersController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!

  # Make sure that every action calls "authorize"
  after_action :verify_authorized

  def show
    authorize @user


    @friends = Kaminari.paginate_array(@user.friends).page(params[:friends]).per(3)


    # something like this? FIXME FIXME FIXME
    Trip.where(:participants => @user.participants, :public => true)

    # FIXME
    #@public_trips = Kaminari.paginate_array(Trip.where(:id => Participant.where(:user => @user), :public => true)).page(params[:trips]).per(5)
    @public_trips = Kaminari.paginate_array(Trip.all).page(params[:trips]).per(5)

  end

  def edit
    authorize @user, :update?
  end

  def update
    authorize @user
    if @user.update(user_params)
      redirect_to user_path
    else
      render :edit
    end

  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :age, :country, :town, :status, :image, :gender)
  end

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = I18n.t('user_id_not_found')

    redirect_to dashboard_path
  end
end
