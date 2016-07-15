class HomeController < ApplicationController
	before_action :authenticate_user! , except: :index
	def index
		if user_signed_in?	
			@user = current_user	
			@days =   (((Time.now - @user.start_date)/(3600 * 24)).to_i / 365) * 15	
			if @user.admin
				@users = User.all
			end
		end
	end
end
