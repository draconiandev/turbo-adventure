module Commands
  # Transaction command class
  class Transaction
    def self.transfer(args)
      from_account = args[0]
      to_account = args[1]
      amount = args[2]
      Models::Transaction.transfer(from_account, to_account, amount)
    end

    def self.lend(args)
      to_account = args[0]
      amount = args[1]
      to = Models::User.find_by(account_number: to_account)
      Models::User.add_balance(to, amount)
    end
  end
end
