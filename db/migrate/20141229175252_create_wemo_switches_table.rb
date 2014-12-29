class CreateWemoSwitchesTable < ActiveRecord::Migration
  def change
    create_table :wemo_switches do |t|
      t.timestamps

      t.string :friendly_name, null: false
      t.string :serial_number, null: false
      t.string :ip_address, null: false
      t.integer :port, null: false
    end
  end
end
