class AlterStatusColumnOnBathroom < ActiveRecord::Migration
  def change
    remove_column :bathrooms, :status
    add_column :bathrooms, :status, :integer, default: 0, null: false
  end
end
