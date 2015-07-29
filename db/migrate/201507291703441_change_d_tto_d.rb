class ChangeDTtoD < ActiveRecord::Migration
  def change
  	change_column :events, :time, :date
  end
end
