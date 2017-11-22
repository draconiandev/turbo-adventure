module Commands
  # User command class
  class User
    # Creates a user taking in the args from the command line
    # +args+ takes name, phone, address, email, pan, aadhar, passport,
    # username from the CLI and returns account_number if user is added.
    # The only responsibility of this method is to convert the arguments
    # into a hash object and call the create function from the model.
    def self.create(args)
      args_hash = { name: args[0], phone: args[1], address: args[2],
                    email: args[3], pan: args[4], aadhar: args[5],
                    passport: args[6], username: args[7] }
      Models::User.create_from_cli(args_hash)
    end

    # Lists the user, optionally takes a count as well.
    # By default 20 latest objects are called.
    # Prints the same into a table.
    def self.list(count)
      list = Models::User.order(id: :desc).limit(count)
                         .pluck(:account_number, :username, :balance)
      pretty_print(list)
    end

    # Calls the search class method from the user model and prints into a table
    def self.search_from_cli(query)
      list = Models::User.search(query)
                         .pluck(:account_number, :username, :balance)
      pretty_print(list)
    end

    # A user account can be destroyed by this method.
    def self.destroy(args)
      user = Models::User.find_by(account_number: args.first)
      if user
        user.destroy
        puts 'User deleted'
      else
        puts 'User not found'
      end
    end

    private_class_method

    # Prints the table from an array / nested array
    def self.pretty_print(list)
      require 'terminal-table'
      table = Terminal::Table.new rows: list,
                                  headings: %w[Account\ Number Username Balance]
      puts table
    end
  end
end
