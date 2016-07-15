class Vacation < ApplicationRecord
	belongs_to :user

	before_save :set_available_days

	private


	def set_available_days
		self.disccount_days = search_holidays_calendar(2016) - 1
	end

	def get_available_days
		return (self.start_date.to_date..self.finish_date.to_date).select {|date| ![0,6].include? date.wday } 
	end

	def search_holidays_calendar(year)
		holidaysCalendarDate = get_holidays(year)
		selected_days = get_available_days
		numHolidaysOnVacation = ( selected_days - holidaysCalendarDate).count
	end

	def get_holidays(year)
		cached_holidays = RedisHelper.get(year.to_s)
		if cached_holidays.blank?
			puts "hola"
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
