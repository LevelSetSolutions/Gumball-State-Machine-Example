class CreateGumballMachines < ActiveRecord::Migration
  def change
    create_table :gumball_machines do |t|
      t.string :workflow_state
      t.integer :gumballs

      t.timestamps null: false
    end
  end
end
