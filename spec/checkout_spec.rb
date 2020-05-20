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
end
