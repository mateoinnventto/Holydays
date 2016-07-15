class Vacation < ApplicationRecord
	belongs_to :user
	
	validate :validate_date_range, :validate_check_user_available_days

	before_validation :set_available_days
	after_save :delete_cache
	after_destroy :delete_cache


	private

	def  validate_date_range
		if  self.start_date > self.finish_date
			errors.add( :base , 'U don\' t  a time machine !!!')
		end
	end

	def validate_check_user_available_days
		user = User.find(self.user_id) 
		if user.get_vacations_days < self.discount_days
			errors.add(:base , 'Days of vacations are more than the days permitted')
		end
	end

	def set_available_days
		self.discount_days = search_holidays_calendar - 1
	end

	def delete_cache
		RedisHelper.delete("#{User::CACHE_KEYS[:user_vacations]}#{self.user_id}")
	end

	def get_available_days
		return (self.start_date.to_date..self.finish_date.to_date).select {|date| ![0,6].include? date.wday } 
	end

	def search_holidays_calendar
		holidaysCalendarDate = (get_holidays(self.start_date.year) + get_holidays(self.finish_date.year)).uniq
		selected_days = get_available_days
		numHolidaysOnVacation = ( selected_days - holidaysCalendarDate).count
	end

	def get_holidays(year)
		puts "Getting holidays for year #{year}"
		cached_holidays = RedisHelper.get(year.to_s)
		if cached_holidays.blank?
			agent = Mechanize.new
			page = agent.get('http://www.timeanddate.com/holidays/colombia/#{year}')
			holidaysCalendar = page.search('tbody > tr >th')
			holidaysCalendarDate = []
			holidaysCalendar.each do |hc|
				holidaysCalendarDate.unshift(Date.parse "#{hc.text} #{year}")
			end
			holidaysCalendarDate = holidaysCalendarDate.uniq
			data = holidaysCalendarDate.map {|date| date.strftime("%Y-%m-%d")}
			RedisHelper.set(year.to_s, data.to_s)
			return holidaysCalendarDate
		else
			cached_holidays = JSON.parse cached_holidays
			cached_holidays = cached_holidays.map {|date| date.to_date}
			return cached_holidays
		end
	end
end
