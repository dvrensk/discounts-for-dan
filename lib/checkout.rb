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
  end

  def scan(code)
    CATALOG.fetch(code)
  end
end
