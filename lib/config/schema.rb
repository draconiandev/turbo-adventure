require 'active_record'

# Maintain the schema
ActiveRecord::Schema.define(version: 1) do
  unless ActiveRecord::Base.connection.table_exists? :users
    create_table :users, force: :cascade do |t|
      t.string  :name,          default: '', null: false
      t.string  :phone,         default: '', null: false
      t.text    :address,       default: '', null: false
      t.string  :email,         default: '', null: false
      t.string  :pan,           default: '', null: false
      t.string  :aadhar,        default: '', null: false
      t.string  :passport
      t.string  :username
      t.string  :account_number, default: '', null: false
      t.decimal :balance,        default: 0,  null: false
    end
  end

  unless ActiveRecord::Base.connection.table_exists? :transactions
    create_table :transactions, force: :cascade do |t|
      t.references :sender,   default: '', null: false
      t.references :receiver, default: '', null: false
      t.decimal    :amount,   default: 0,  null: false
    end
  end
end
