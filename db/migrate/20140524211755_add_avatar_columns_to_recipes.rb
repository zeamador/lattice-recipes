class AddAvatarColumnsToRecipes < ActiveRecord::Migration
  def self.up
    add_attachment :recipes, :avatar
  end

  def self.down
    remove_attachment :recipes, :avatar
  end
end
