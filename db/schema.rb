# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140513235634) do

  create_table "equipment", force: true do |t|
    t.integer  "burner",     default: 0
    t.integer  "oven",       default: 0
    t.integer  "microwave",  default: 0
    t.integer  "sink",       default: 0
    t.integer  "toaster",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingredients", force: true do |t|
    t.string   "description"
    t.float    "quantity"
    t.string   "unit"
    t.integer  "recipe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ingredients", ["recipe_id"], name: "index_ingredients_on_recipe_id"

  create_table "kitchens", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "burner",     default: 4
    t.integer  "oven",       default: 1
    t.integer  "microwave",  default: 1
    t.integer  "sink",       default: 2
    t.integer  "toaster",    default: 1
  end

  create_table "meals", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipes", force: true do |t|
    t.string  "title"
    t.boolean "secret"
    t.string  "tags"
    t.integer "user_id"
  end

  add_index "recipes", ["user_id"], name: "index_recipes_on_user_id"

  create_table "step_mappers", force: true do |t|
    t.boolean  "immediate_prereq"
    t.boolean  "preheat_prereq"
    t.integer  "prereq_id"
    t.integer  "prereq_step_number"
    t.integer  "step_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "step_mappers", ["step_id"], name: "index_step_mappers_on_step_id"

  create_table "steps", force: true do |t|
    t.text     "description"
    t.integer  "time"
    t.integer  "attentiveness"
    t.integer  "step_number"
    t.boolean  "final_step"
    t.integer  "recipe_id"
    t.integer  "equipment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "steps", ["equipment_id"], name: "index_steps_on_equipment_id"
  add_index "steps", ["recipe_id"], name: "index_steps_on_recipe_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "kitchen_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["kitchen_id"], name: "index_users_on_kitchen_id"
  add_index "users", ["name"], name: "index_users_on_name", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
