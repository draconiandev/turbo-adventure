# Namespaces all the models so it doesn't conflict with commands
module Models
  require 'active_record'
  # Defines the Transaction class. Provides a wrapper for transfer method.
  class Transaction < ActiveRecord::Base
    INSUFFICIENT_FUNDS_MESSAGE =
      'sender does not have enough balance to transfer this amount'.freeze

    belongs_to :receiver, class_name: 'User', foreign_key: :receiver_id
    belongs_to :sender, class_name: 'User', foreign_key: :sender_id

    # Check whether the transaction can happen. All the race conditions
    # can go within this method.
    validate :can_transfer?

    # Amount must always be greater than 0 for a transfer to happen.
    validates :amount, numericality: { greater_than: 0 }

    # This callback calculates the balance of the sender and the receiver
    # after the transaction.
    after_create :calculate_balance

    # Wrapper for the transfer transaction.
    # Takes +from+, +to+ and the +amount+.
    # +from+ and +to+ will be the account numbers of the users.
    # +from+ represents the sender while +to+ represents the receiver.
    # If either of the users are not found, invalid accounts is printed.
    # Returns a confirmation message if transaction happens,
    # else prints the error messages.
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
      puts 'Something went wrong with the command. Please review the errors'
      transact.errors.messages.each do |key, msg|
        puts key.to_s + ' -> '
        msg.each { |m| puts m.capitalize }
      end
    end

    private

    # Can transfer only if the balance of the sender is greater than the amount
    # the user is trying to send.
    def can_transfer?
      return if sender.balance >= amount
      errors.add(:amount, INSUFFICIENT_FUNDS_MESSAGE)
    end

    # Finally, calculates the balances of the sender and the receiver.
    # Both updates pessimistically locks the user record so that concurrency
    # problems can be minimized.
    def calculate_balance
      update_sender
      update_receiver
    end

    def update_sender
      sender.with_lock do
        sender.update(balance: sender.balance - amount)
      end
    end

    def update_receiver
      receiver.with_lock do
        receiver.update(balance: receiver.balance + amount)
      end
    end
  end
end
