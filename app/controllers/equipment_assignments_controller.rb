class EquipmentAssignmentsController < EquipmentItemsController
    before_action :authenticate_user!
    before_action :set_equipment_item
    before_action :set_equipment_list
    before_action :set_equipment_assigment, :only => [:show, :update, :edit, :destroy]
    before_action :set_trip

    def create
        authorize @trip, :show?

        @equipment_assignment = EquipmentAssignment.create(equipment_assignment_params)

        #@equipment_assignment.user_id = current_user.id

        # Assign to other people
         if params[:user_email].blank?
           @equipment_assignment.user_id = current_user.id
         else 
           user = User.find_by(:email => params[:user_email])
           if user && @trip.participants.find_by(:user_id => user.id) 
               @equipment_assignment.user_id = user.id
           else
               flash[:alert] = I18n.t 'trip_partipant_not_found'
               render :new
               return
           end
         end

        @equipment_assignment.equipment_item_id = @equipment_item.id


        if @equipment_assignment.save
            flash[:notice] = I18n.t 'trip_equipment_assignment_created'
            redirect_to trip_equipment_list_equipment_item_path(@trip, @equipment_list, @equipment_item)
        else 
            flash[:alert] = I18n.t 'trip_equipment_assignment_not_created'
            render :new
        end
    end

    def edit
       unless current_user.id == @equipment_assignment.user_id 
           authorize @trip, :update?
       end
       render 'edit' 
    end

    def update
        unless current_user.id == @equipment_assignment.user_id 
            authorize @trip
        end

        if @equipment_assignment.update(equipment_assignment_params)
            flash[:notice] = I18n.t 'trip_equipment_assignment_updated'
            redirect_to trip_equipment_list_equipment_item_path(@trip, @equipment_list, @equipment_item)
        else 
            flash[:alert] = I18n.t 'trip_equipment_assignment_not_updated'
            render 'edit'
        end
    end

    def destroy
        unless current_user.id == @equipment_assignment.user_id
            authorize @trip
        end

        @equipment_assignment.destroy
        flash[:notice] = I18n.t 'trip_equipment_assignment_deleted'
        redirect_to trip_equipment_list_equipment_item_path(@trip, @equipment_list, @equipment_item)
    end

    protected
    def set_equipment_assigment
        @equipment_assignment = EquipmentAssignment.find(params[:id])
        rescue ActiveRecord::RecordNotFound
            flash[:alert] = I18n.t 'trip_equipment_assignment_not_found'
            redirect_to :back
    end

    def set_equipment_item
        @equipment_item = EquipmentItem.find(params[:equipment_item_id])
        rescue ActiveRecord::RecordNotFound
            flash[:alert] = I18n.t 'trip_equipment_list_equipment_item_not_found'
            redirect_to :back
    end    

    private


    def equipment_assignment_params
        params.require(:equipment_assignment).permit(:number)
    end

    def authorize_assigment 
        unless current_user.id == @equipment_assignment.user_id
            authorize @trip, :update?
        end
    end
end
