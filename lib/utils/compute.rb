module Utils
  # Computes the interest based on formula for given principal
  class Compute
    # annual rate of interest (as a decimal)
    INTEREST_RATE = 0.04

    # number of times the interest is compounded per year
    COMPOUND_RATE = 12

    # number of years the amount is deposited or borrowed for
    TOTAL_YEARS = 1

    def self.calculate_interest_for(principal)
      times = COMPOUND_RATE * TOTAL_YEARS
      factorial = (1 + (INTEREST_RATE / COMPOUND_RATE))**times
      total_amount = principal * factorial
      total_amount - principal
    end
  end
end
