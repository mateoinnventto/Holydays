class AddDiscountDaysToVacations < ActiveRecord::Migration[5.0]
  def change
  	add_column :vacations, :discount_days, :numeric
  end
end
