module Rules
  class BulkPrice
    def initialize(start_at:, drop_to:, code:)
      @start_at, @drop_to, @code = start_at, drop_to, code.freeze
    end

    attr_reader :start_at, :drop_to, :code

    Discount = Struct.new(:amount, :items)

    def generate_discounts(items)
      # Use === for matching to allow regexen as well as strings
      matching = items.select { |i| code === i.code }
      return [] unless matching.size >= start_at

      if drop_to.is_a? Rational
        full_price = matching.sum(&:price)
        drop = 1 - drop_to
        Discount.new(full_price * drop.numerator / drop.denominator, matching)
      else
        matching.map { |i| Discount.new(i.price - drop_to, i) }
      end
    end
  end
end
