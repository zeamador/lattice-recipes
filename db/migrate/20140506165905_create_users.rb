class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.references :kitchen, index: true

      t.timestamps
    end
  end
end
