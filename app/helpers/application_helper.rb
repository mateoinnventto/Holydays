module ApplicationHelper
	def resource_name
		:user
	end

	def resource
		@resource ||= current_user
		@resource ||= User.new
	end

	def devise_mapping
		@devise_mapping ||= Devise.mappings[:user]
	end
end
