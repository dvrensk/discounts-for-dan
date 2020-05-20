# frozen_string_literal: true
require "bigdecimal"

class Checkout
  CATALOG = {
    "GR1" => BigDecimal("3.11"),
    "SR1" => BigDecimal("5.00"),
    "CF1" => BigDecimal("11.23"),
  }.freeze

  def initialize(rules)
    @rules = rules
    @scanned = []
  end

  attr_reader :rules, :scanned
  private :rules, :scanned

  LineItem = Struct.new(:code, :price)

  def scan(code)
    price = CATALOG.fetch(code)
    scanned << LineItem.new(code, price)
  end

  def total
    discounts = rules.flat_map { |r| r.generate_discounts(scanned) }
    scanned.sum(&:price) - discounts.sum(&:amount)
  end
end
