class HomeController < ApplicationController
	before_action :authenticate_user! , except: :index
	def index
		if user_signed_in?	
			@user = current_user	
			@days =   @user.get_vacations_days 	
			if @user.admin
				@users = User.all
			end
		end
	end
end
