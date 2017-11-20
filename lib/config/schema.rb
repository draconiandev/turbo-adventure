require 'active_record'

ActiveRecord::Schema.define(version: 1) do
  create_table :users, force: :cascade do |t|
    t.string :name, default: '', null: false
    t.string :phone, default: '', null: false
    t.string :address, default: '', null: false
    t.string :email, default: '', null: false
    t.string :pan, default: '', null: false
    t.string :aadhar, default: '', null: false
    t.string :passport
    t.string :username
    t.string :account_number, default: '', null: false
  end
end
