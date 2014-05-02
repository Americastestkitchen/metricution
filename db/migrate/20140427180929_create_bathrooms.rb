class CreateBathrooms < ActiveRecord::Migration
  def change
    create_table :bathrooms do |t|
      t.string :name
      t.string :sparkcore_id

      t.timestamps
    end
  end
end
