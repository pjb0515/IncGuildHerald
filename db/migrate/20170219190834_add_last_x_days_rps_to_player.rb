class AddLastXDaysRpsToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :last_three_days_rps, :integer, default: 0
    add_column :players, :last_seven_days_rps, :integer, default: 0
    add_column :players, :last_fourteen_days_rps, :integer, default: 0
  end
end
