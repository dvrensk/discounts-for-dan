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

  context 'buy 1 get 1 free' do
    let(:rules) { [Rules::BuyNGetMFree.new(1, 1, "GR1")] }

    it 'sells 2 at the price of 1' do
      2.times { checkout.scan("GR1") }
      expect(checkout.total).to eq 3.11.to_d
    end

    it 'sells 5 at the price of 3' do
      5.times { checkout.scan("GR1") }
      expect(checkout.total).to eq(3.11.to_d * 3)
    end
  end
end
