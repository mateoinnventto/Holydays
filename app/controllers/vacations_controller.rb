class VacationsController < ApplicationController
	before_action :set_user
	def index
		@vacation = @user.vacations
	end

	def create
		@vacation = @user.vacations.create(vacation_params)
		@vacation.save
		redirect_to user_vacations_path
	end

	def new
		@vacation = Vacation.new
	end

	private

	def set_user
		@user = User.find(params[:user_id]) 
	end

	def vacation_params
		params.require(:vacation).permit(:start_date , :finish_date)
	end
end
