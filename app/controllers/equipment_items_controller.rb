class EquipmentItemsController < ApplicationController
    layout 'trip'

    before_action :authenticate_user!
    before_action :set_equipment_list
    before_action :set_equipment_item, :only => [:show, :update, :edit, :destroy]
    before_action :set_trip

    def index
    end

    def show
        @equipment_assignment = EquipmentAssignment.new
    end

    def new
        authorize @trip, :update?
        @equipment_item = EquipmentItem.new        
    end

    def create
        authorize @trip, :update?
        @equipment_item = EquipmentItem.create(equipment_item_params)
        @equipment_item.equipment_list = @equipment_list
        @equipment_item.user_id = current_user.id

        if @equipment_item.save 
            flash[:notice] = I18n.t 'trip_equipment_list_equipment_item_created'
            redirect_to trip_equipment_list_path(@trip, @equipment_list)
        else
            flash[:alert] = I18n.t 'trip_equipment_list_equipment_item_not_created'
            render :new
        end 
    end

    def update
        authorize @trip
        if @equipment_item.update(equipment_item_params)
            flash[:notice] = I18n.t 'trip_equipment_list_equipment_item_updated'
            redirect_to trip_equipment_list_path(@trip, @equipment_list)
        else
            flash[:alert] = I18n.t 'trip_equipment_list_equipment_item_not_updated'
            render 'edit'
        end
    end

    def edit
        authorize @trip, :update?
        render 'edit'
    end

    def destroy
        # if the current user did create the item, the user should be able to delete it again!
        unless current_user.id == @equipment_item.user_id
            # owner should we able to delete the item anyways
            authorize @trip
        end

        @equipment_item.destroy
        flash[:notice] = I18n.t 'trip_equipment_list_equipment_item_deleted'
        redirect_to trip_equipment_list_path(@trip, @equipment_list)
    end

    protected
    def set_equipment_list
        @equipment_list = EquipmentList.find(params[:equipment_list_id])
        rescue ActiveRecord::RecordNotFound
            flash[:alert] = I18n.t 'trip_equipment_list_not_found'
            redirect_to :back
    end

    def set_equipment_item
        @equipment_item = EquipmentItem.find(params[:id])
        rescue ActiveRecord::RecordNotFound
            flash[:alert] = I18n.t 'trip_equipment_list_equipment_item_not_found'
            redirect_to :back
    end

    def set_trip
        @trip = @equipment_list.trip
        rescue ActiveRecord::RecordNotFound
            flash[:alert] = I18n.t 'trip_not_found'
            redirect_to :back
    end
    
    private
    def equipment_item_params
        params.require(:equipment_item).permit(:name, :price, :number)
    end
end
