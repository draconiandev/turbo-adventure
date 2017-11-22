require 'sqlite3'
require 'active_record'

# Connect to the database
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'transactor.db'
)
