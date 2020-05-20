describe Checkout do

  let(:checkout) { Checkout.new(rules) }
  let(:rules) { [] }

  context '.new' do
    it 'creates an instance, given rules' do
      expect(checkout).to be_a Checkout
    end
  end
  
end
