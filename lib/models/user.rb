# Namespaces all the models so it doesn't conflict with commands
module Models
  require 'active_record'
  # Defines the User class. Also provides a wrapper for add,
  # list and remove methods
  class User < ActiveRecord::Base
    has_many :sent_transactions, class_name: 'Transaction',
                                 foreign_key: :sender_id
    has_many :received_transactions, class_name: 'Transaction',
                                     foreign_key: :receiver_id

    validates :balance, numericality: { greater_than_or_equal_to: 0 }
    before_create :generate_account_number

    def self.create_from_cli(args)
      user = new(args)
      if user.save
        puts 'Account Number for the created account: ' + user.account_number
      else
        print_error_messages(user)
      end
    end

    def self.search(query)
      where('account_number OR name LIKE ?', "%#{query}%").order(id: :desc)
    end

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

    def self.print_error_messages(user)
      puts 'Something went wrong with the transaction. Please review the errors'
      user.errors.messages.each do |key, msg|
        puts key.to_s + ' -> '
        msg.each { |m| puts m.capitalize }
      end
    end

    def self.invalid_amount
      puts 'Amount must be positive'
    end

    private

    def generate_account_number
      return if account_number.present?
      self.account_number = generate_account_token
    end

    def generate_account_token
      require 'securerandom'
      loop do
        token = SecureRandom.hex(3).upcase
        break token unless User.find_by(account_number: token)
      end
    end
  end
end
