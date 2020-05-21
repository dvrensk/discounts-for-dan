require 'bigdecimal/util'

describe Checkout do

  # | Product code | Name         | Price  |
  # | ------------ | ----         | ----:  |
  # | GR1          | Green tea    | £3.11  |
  # | SR1          | Strawberries | £5.00  |
  # | CF1          | Coffee       | £11.23 |

  let(:checkout) { Checkout.new(rules) }
  let(:rules) { [] }

  describe '.new' do
    it 'creates an instance, given rules' do
      expect(checkout).to be_a Checkout
    end
  end

  describe '#scan' do
    it 'accepts known product codes' do
      expect { checkout.scan("GR1") }.not_to raise_error
    end

    it 'complains about unknown codes' do
      expect { checkout.scan("XX1") }.to raise_error(KeyError)
    end
  end

  describe '#total' do
    it 'does addition' do
      checkout.scan("GR1")
      checkout.scan("SR1")
      expect(checkout.total).to eq 8.11.to_d
    end
  end

  let(:tea_rule) { Rules::BuyNGetMFree.new(n: 1, m: 1, code: "GR1") }
  context 'buy 1 get 1 free' do
    let(:rules) { [tea_rule] }

    it 'sells 2 at the price of 1' do
      2.times { checkout.scan("GR1") }
      expect(checkout.total).to eq 3.11.to_d
    end

    it 'sells 5 at the price of 3' do
      5.times { checkout.scan("GR1") }
      expect(checkout.total).to eq(3.11.to_d * 3)
    end
  end

  # * The COO, though, likes low prices and wants people buying
  # strawberries to get a price discount for bulk purchases. If
  # you buy 3 or more strawberries, the price should drop to £4.50
  let(:strawberries_rule) { Rules::BulkPrice.new(start_at: 3, drop_to: 4.50.to_d, code: "SR1") }
  context 'bulk pricing' do
    let(:rules) { [strawberries_rule] }

    it 'starts bulk pricing at 3 units' do
      2.times { checkout.scan("SR1") }
      expect(checkout.total).to eq(5.00.to_d * 2)
      1.times { checkout.scan("SR1") }
      expect(checkout.total).to eq(4.50.to_d * 3)
    end
  end

  # * The CTO is a coffee addict. If you buy 3 or more coffees,
  # the price of all coffees should drop to two thirds of the
  # original price.
  let(:coffee_rule) { Rules::BulkPrice.new(start_at: 3, drop_to: 2.to_r/3, code: "CF1") }
  context 'bulk pricing with fractions' do
    let(:rules) { [coffee_rule] }

    it 'starts bulk pricing at 3 units' do
      2.times { checkout.scan("CF1") }
      expect(checkout.total).to eq(11.23.to_d * 2)
      1.times { checkout.scan("CF1") }
      expect(checkout.total).to eq(11.23.to_d * 2)
      1.times { checkout.scan("CF1") }
      expect(checkout.total).to be_within(0.005).of(11.23 * 4 * 2/3)
    end
  end

  context 'acceptance testing' do
    let(:rules) { [tea_rule, strawberries_rule, coffee_rule] }

    it 'handles Basket GR1,SR1,GR1,GR1,CF1 => ​£22.45' do |example|
      expected_total = shop(example)
      expect(checkout.total).to eq expected_total
    end
  
    it 'handles Basket GR1,GR1 => ​£3.11' do |example|
      expected_total = shop(example)
      expect(checkout.total).to eq expected_total
    end
  
    it 'handles Basket SR1,SR1,GR1,SR1 => £16.61' do |example|
      expected_total = shop(example)
      expect(checkout.total).to eq expected_total
    end
  
    it 'handles Basket GR1,CF1,SR1,CF1,CF1 => £30.57' do |example|
      expected_total = shop(example)
      expect(checkout.total).to eq expected_total
    end
  
  end

  def shop(example)
    codes, total = example.description.match(/Basket (\S+)[^£]+£(\S+)/)[1..2]
    codes.split(',').each { |code| checkout.scan(code) }
    total.to_d
  end
end
