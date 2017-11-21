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

    before_create :generate_account_number

    def self.create_from_cli(args)
      user = new(args)
      if user.save
        puts 'Account Number for the created account: ' + user.account_number
      else
        p user.errors
      end
    end

    def self.search(query)
      where('account_number OR name LIKE ?', "%#{query}%").order(id: :desc)
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
