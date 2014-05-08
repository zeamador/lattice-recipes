class CreateKitchens < ActiveRecord::Migration
  def change
    create_table :kitchens do |t|

      t.timestamps
    end
  end
end
