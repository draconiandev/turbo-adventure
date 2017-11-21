# Namespaces all the models so it doesn't conflict with commands
module Models
  require 'active_record'
  # Defines the Transaction class. Provides a wrapper for transfer method.
  class Transaction < ActiveRecord::Base
    belongs_to :receiver, class_name: 'User', foreign_key: :receiver_id
    belongs_to :sender, class_name: 'User', foreign_key: :sender_id

    validate :can_transfer?
    validates :amount, numericality: { greater_than: 0 }

    after_create :calculate_balance

    def self.transfer(from, to, amount)
      from_user = Models::User.find_by(account_number: from)
      to_user = Models::User.find_by(account_number: to)
      return not_valid_accounts unless from_user && to_user
      transact = new(sender_id: from_user.id,
                     receiver_id: to_user.id,
                     amount: amount)
      handle_save(transact, amount, from_user, to_user)
    end

    private_class_method

    def self.not_valid_accounts
      puts 'Not valid accounts'
    end

    def self.handle_save(transact, amount, from_user, to_user)
      if transact.save
        puts amount + ' has been transferred from ' + from_user.name + ' to ' +
             to_user.name
      else
        print_error_messages(transact)
      end
    end

    def self.print_error_messages(transact)
      puts 'Something went wrong with the transaction. Please review the errors'
      transact.errors.messages.each do |key, msg|
        puts key.to_s + ' -> '
        msg.each { |m| puts m.capitalize }
      end
    end

    private

    def can_transfer?
      return if sender.balance >= amount
      errors.add(:amount, 'sender does not have enough balance to transfer this amount')
    end

    def calculate_balance
      sender.update(balance: sender.balance - amount)
      receiver.update(balance: receiver.balance + amount)
    end
  end
end
