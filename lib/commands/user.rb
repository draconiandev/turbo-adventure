module Commands
  # User command class
  class User
    # Creates a user taking in the args from the command line
    # @param -> args => [name, phone, address, email, pan, aadhar, passport,
    #                    username]
    # returns account_number if user is added
    # raises ArgumentError if user is not added due to bad arguments
    def self.create(args)
      # name, phone, address, email, pan, aadhar, passport, username = args
      # Models::User.create(name: name, phone: phone, address: address,
      #                     email: email, pan: pan, aadhar: aadhar,
      #                     passport: passport, username: username)
      args_hash = { name: args[0], phone: args[1], address: args[2],
                    email: args[3], pan: args[4], aadhar: args[5],
                    passport: args[6], username: args[7]
    }
      Models::User.create_from_cli(args_hash)
    end

    def self.list(count)
      require 'terminal-table'
      list = Models::User.order(id: :desc).limit(count).pluck(:name, :account_number)
      table = Terminal::Table.new rows: list
      puts table
    end

    def remove
      #
    end
  end
end
