module Rules
  class BuyNGetMFree
    def initialize(n:, m:, code:)
      @n, @m, @code = n, m, code.freeze
    end

    attr_reader :n, :m, :code

    def generate_discounts(items)
      # Use === for matching to allow regexen as well as strings
      matching = items.select { |i| code === i.code }
      # TODO: if items can have varying prices, sort by price
      matching
      .each_slice(n+m)
      .select { |e| e.size == n + m }
      .map do |slice|
        amount = slice[0...m].sum { |i| i.price }
        Discount.new(amount, slice)
      end
    end
  end
end
