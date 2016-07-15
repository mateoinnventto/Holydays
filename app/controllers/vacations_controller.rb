class VacationsController < ApplicationController
	before_action :set_user
	def index
		@vacation = @user.vacations.order(:start_date)
	end

	def create
		@vacation = @user.vacations.create(vacation_params)
		duration = ((@vacation.finish_date - @vacation.start_date)/(3600*24)).to_i 
		#@vacation.discount_days = @vacation.search_holidays_calendar(@vacation.start_date.year)  - 1
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
		params.require(:vacation).permit(:start_date , :finish_date,:discount_days)
	end


end
