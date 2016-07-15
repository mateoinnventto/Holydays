class VacationsController < ApplicationController
	before_action :set_user
	def index
		@vacation = @user.vacations.order(:start_date)
	end

	def destroyd
		@vacations = Vacation.find(params[:id])
		@vacations.destroy
		redirect_to user_vacations_path
	end

	def edit
		@vacation = Vacation.find(params[:id])
	end

	def update
		@vacation = Vacation.find(params[:id])

		if @vacation.update(vacation_params)
			redirect_to user_vacations_path
		else
			render 'edit'
		end
	end

	def create
		@vacation = @user.vacations.create(vacation_params)
		duration = ((@vacation.finish_date - @vacation.start_date)/(3600*24)).to_i 
		if @vacation.save
			return redirect_to user_vacations_path
		else
			return render :new
		end

	end

	def new
		@vacation = Vacation.new
	end

	private

	def set_user
		@user = User.find(params[:user_id]) 
	end

	def vacation_params
		params.require(:vacation).permit(:start_date , :finish_date,:discount_days)
	end


end
