module Commands
  # Transaction command class
  class Transaction
    def self.transfer(args)
      from_account = args[0]
      to_account = args[1]
      amount = args[2]
      Models::Transaction.transfer(from_account, to_account, amount)
    end
  end
end
