# frozen_string_literal: true

# Namespaces all the models so it doesn't conflict with commands
module Models
  require 'active_record'
  # Defines the User class. Also provides a wrapper for add,
  # list and remove methods
  class User < ActiveRecord::Base
    # At least one alphabetic character (the [a-z] in the middle).
    # Does not begin or end with an underscore (the (?!_) and (?<!_)
    # at the beginning and end.
    # May have any number of numbers, letters, or underscores before
    # and after the alphabetic character, but every underscore must be
    # separated by at least one number or letter (the rest).
    USERNAME_FORMAT = /\A(?!_)(?:[a-z0-9]_?)*[a-z](?:_?[a-z0-9])*(?<!_)\z/i

    # May start with 7, 8 or 9 and must have 9 more digits.
    # Country codes are not being considered as of now.
    PHONE_FORMAT = /[789]\d{9}/i

    # Plain names only. No digits or special chars
    NAME_FORMAT = /\A[a-zA-Z. ]*\z/

    # Must contain 5 alphabets in the start followed by 4 digits and an alphabet
    PAN_FORMAT = /[a-zA-z]{5}\d{4}[a-zA-Z]{1}/

    # Must be 12 digit long numeric
    AADHAR_FORMAT = /\d{12}/

    # Must start with an alphabet that is not Q, X or Z, followed by a digit that is not 0
    # There can be an optional space followed by 4 digit long numbers which are not 0
    # Taken from https://marketplace.informatica.com/solutions/validate_indian_passport_regex
    PASSPORT_FORMAT = /[a-pr-wyA-PR-WY][1-9]\d\s?\d{4}[1-9]/

    USERNAME_MESSAGE = 'only alphabets, digits and underscores allowed'.freeze
    PHONE_MESSAGE = 'must start with 7, 8, or 9'.freeze
    NAME_MESSAGE = 'please use only English Alphabets'.freeze
    PAN_MESSAGE = 'not a valid format'.freeze
    AADHAR_MESSAGE = 'must contain only digits'.freeze
    PASS_MESSAGE = 'not a valid format'.freeze

    # Can easily track sent transactions and received transactions
    # rather than having a singular has_many.
    has_many :sent_transactions, class_name: 'Transaction',
                                 foreign_key: :sender_id
    has_many :received_transactions, class_name: 'Transaction',
                                     foreign_key: :receiver_id

    # Balance must always be greater than or equal to zero.
    # It cannot be a non numeric.
    validates :balance, numericality: { greater_than_or_equal_to: 0 }

    validates :name, :email, :phone, :pan, :aadhar,
              :passport, :address, presence: true

    validates :email, :phone, :account_number,
              uniqueness: { case_sensitive: false }

    validates :phone, length: { is: 10 },
                      format: { with:    PHONE_FORMAT,
                                message: PHONE_MESSAGE }

    validates :username, length: { in: 4..40 },
                         uniqueness: { case_sensitive: false },
                         format: { with:    USERNAME_FORMAT,
                                   message: USERNAME_MESSAGE },
                         allow_blank: true

    validates :name, format: { with: NAME_FORMAT, message: NAME_MESSAGE }

    validates :pan, length: { is: 10 },
                    format: { with: PAN_FORMAT, message: PAN_MESSAGE }

    validates :aadhar, length: { is: 12 },
                       format: { with: AADHAR_FORMAT, message: AADHAR_MESSAGE }

    validates :passport, length: { is: 8 },
                         format: { with: PASSPORT_FORMAT, message: PASS_MESSAGE },
                         allow_blank: true

    # Generates an account number just before the account is generated.
    before_create :generate_account_number

    # Wrapper for create action with custom error message formats.
    # Used in Commands::User
    # Creates a new user described by +args+ and returns account number of user.
    # If the +args+ hash is not valid, a custom error message will be printed.
    def self.create_from_cli(args)
      user = new(args)
      if user.save
        puts 'Account Number for the created account: ' + user.account_number
      else
        print_error_messages(user)
      end
    end

    # Wrapper for searching a user.
    # +query+ can either be username or an account number.
    # Returns a list of users matching the query.
    # By using advanced DBs like PostgreSQL, native `similarity` function could
    # have been used to get better matches.
    # Ex:
    # term = "similarity(param, #{ActiveRecord::Base.connection.quote(q)}) DESC"
    # where('similarity(param, ?) > 0.15', q).order(term)
    def self.search(query)
      where('account_number OR username LIKE ?', "%#{query}%").order(id: :desc)
    end

    # Wrapper to add balance to a user's account.
    # Takes +to+ and +amount+
    # +to+ represents the user account whose balance is being added.
    # +amount+ represents the amount that needs to be transferred.
    # `Float(amount)` checks if the +amount+ is indeed a numeric, else
    # it raises argument error which will be rescued by printing appropriate
    # help text.
    # Also, the amount must be positive. Else, help text will be printed.
    def self.add_balance(to, amount)
      normalized_amount = Float(amount)
      return invalid_amount unless normalized_amount.positive?
      if to.update(balance: to.balance + normalized_amount)
        puts amount + ' has been credited to ' + to.name
      else
        p to.errors
      end
    rescue ArgumentError
      puts 'Invalid amount. Please use either an integer or a decimal.'
    end

    private_class_method

    # Prints the errors messages in an easy to read format.
    # Can be extended by a module since it is repeating in both the models.
    def self.print_error_messages(user)
      puts 'Something went wrong with the command. Please review the errors'
      user.errors.messages.each do |key, msg|
        puts key.to_s + ' -> '
        msg.each { |m| puts m.capitalize }
      end
    end

    def self.invalid_amount
      puts 'Amount must be positive'
    end

    private

    # No need to generate the token if an account number is already present.
    # Can also be taken out, but gives some sort of cushion if someone accidentaly
    # changes the callback to before_save
    def generate_account_number
      return if account_number.present?
      self.account_number = generate_account_token
    end

    # Requires `securerandom`.
    # SecureRandom.hex(3) gives a 6 character long alphanumeric string
    # which will be upcased before saving. If we want to change the length of
    # account number, change the number here. The character length will be
    # twice the `number_of_bytes` that we pass in as argument.
    # SecureRandom.hex(3) => "2c1083"
    # SecureRandom.hex(4) => "2bb093ed"
    def generate_account_token
      require 'securerandom'
      loop do
        token = SecureRandom.hex(3).upcase
        break token unless User.find_by(account_number: token)
      end
    end
  end
end
