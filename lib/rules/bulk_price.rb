module Rules
  class BulkPrice
    def initialize(start_at, bulk_price, code)
      @start_at, @bulk_price, @code = start_at, bulk_price, code.freeze
    end

    attr_reader :start_at, :bulk_price, :code

    Discount = Struct.new(:amount, :items)

    def generate_discounts(items)
      # Use === for matching to allow regexen as well as strings
      matching = items.select { |i| code === i.code }
      return [] unless matching.size >= start_at

      matching.map { |i| Discount.new(i.price - bulk_price, i) }
    end
  end
end
