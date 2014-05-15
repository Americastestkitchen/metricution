class AddStatusUpdatedAtToBathrooms < ActiveRecord::Migration
  def change
    add_column :bathrooms, :status_updated_at, :datetime
  end
end
