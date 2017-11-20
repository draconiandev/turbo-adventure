# Namespaces all the models so it doesn't conflict with commands
module Models
  require 'active_record'
  # Defines the User class. Also provides a wrapper for add,
  # list and remove methods
  class User < ActiveRecord::Base
    def print(name)
      p 'printed: ' + name
    end
  end
end
