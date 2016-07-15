class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable
  has_many :vacations, dependent: :destroy

  CACHE_KEYS = {user_vacations: "user_vacations_"}


  def get_vacations_days
  	cache_key = "#{CACHE_KEYS[:user_vacations]}#{self.id}"
   cached_holidays = RedisHelper.get(cache_key)
   if cached_holidays.blank? 
    days = (((Time.now - self.start_date)/(3600 * 24)) / 365) * 15
    total_discount_days = self.vacations.sum(:discount_days)
    days =  (days - total_discount_days)
    RedisHelper.set(cache_key, days, 3600 * 24)
    return days
  else
    return cached_holidays.to_i
  end
end
end
