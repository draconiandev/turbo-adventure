module Commands
  # Compute class
  class Compute
    def self.calculate_interest(args)
      return empty_args if args.empty?
      require 'utils/compute.rb'
      account = args[0].upcase
      statement = 'account_number IS :val OR username IS :val'
      user = Models::User.find_by(statement, val: account)
      return user_not_found unless user
      amount = user.balance
      interest = Utils::Compute.calculate_interest_for(amount)
      puts 'Interest accrued will be: ' + interest.to_f.round(2).to_s
    end

    private_class_method

    def self.user_not_found
      puts 'Error: User not found. Please check the value you have entered.'
    end

    def self.empty_args
      puts 'Error:Enter the username or account number which you want to compute.'
    end
  end
end
