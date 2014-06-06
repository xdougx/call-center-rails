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

ActiveRecord::Schema.define(version: 20140606043411) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "centrais", force: true do |t|
    t.string   "nome"
    t.string   "localizacao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chamadas", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.integer  "funcionario_id"
    t.integer  "central_id"
  end

  create_table "funcionarios", force: true do |t|
    t.string   "nome"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "central_id"
    t.string   "status"
    t.integer  "chamada_andamento_id"
  end

end
