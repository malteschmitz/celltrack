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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130120224156) do

  create_table "cells", :force => true do |t|
    t.integer  "image_id"
    t.integer  "experiment_id"
    t.integer  "path_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.binary   "mask"
    t.integer  "top"
    t.integer  "left"
    t.integer  "center_x"
    t.integer  "center_y"
    t.integer  "width"
    t.integer  "height"
  end

  add_index "cells", ["experiment_id"], :name => "index_cells_on_experiment_id"
  add_index "cells", ["image_id"], :name => "index_cells_on_image_id"
  add_index "cells", ["path_id"], :name => "index_cells_on_path_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "experiments", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "import_progress"
    t.boolean  "import_done"
  end

  create_table "images", :force => true do |t|
    t.integer  "experiment_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "ord"
    t.integer  "width"
    t.integer  "height"
  end

  add_index "images", ["experiment_id"], :name => "index_images_on_experiment_id"
  add_index "images", ["ord"], :name => "index_images_on_ord"

  create_table "paths", :force => true do |t|
    t.integer  "experiment_id"
    t.integer  "tree_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "paths_paths", :id => false, :force => true do |t|
    t.integer "pred_path_id"
    t.integer "succ_path_id"
  end

  add_index "paths_paths", ["pred_path_id"], :name => "index_paths_paths_on_pred_path_id"
  add_index "paths_paths", ["succ_path_id"], :name => "index_paths_paths_on_succ_path_id"

  create_table "pictures", :force => true do |t|
    t.integer  "image_id"
    t.integer  "experiment_id"
    t.string   "filename"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "pictures", ["experiment_id"], :name => "index_pictures_on_experiment_id"
  add_index "pictures", ["image_id"], :name => "index_pictures_on_image_id"

  create_table "trees", :force => true do |t|
    t.integer  "experiment_id"
    t.integer  "root_path_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "trees", ["experiment_id"], :name => "index_trees_on_experiment_id"
  add_index "trees", ["root_path_id"], :name => "index_trees_on_root_path_id"

end
