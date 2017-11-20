module Commands
  # User command class
  class User
    # Creates a user taking in the args from the command line
    # @param -> args => [name, phone, address, email, pan, aadhar, passport,
    #                    username]
    # returns account_number if user is added
    # raises ArgumentError if user is not added due to bad arguments
    def create(args)
      # name, phone, address, email, pan, aadhar, passport, username = args
      # Models::User.create(name: name, phone: phone, address: address,
      #                     email: email, pan: pan, aadhar: aadhar,
      #                     passport: passport, username: username)
      name = args
      Models::User.new.print(name.first)
    end

    def list
      #
    end

    def remove
      #
    end
  end
end
