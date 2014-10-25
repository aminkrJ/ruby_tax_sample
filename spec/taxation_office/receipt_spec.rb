require 'spec_helper'

describe TaxationOffice::Receipt do
  before(:each) do
    @receipt = TaxationOffice::Receipt.new
  end

  context "receipt with purchase items" do
    before(:each) do
      @receipt.items.push instance_double('Item', total_price: 10.0, purchase_tax: 1.0)
      @receipt.items.push instance_double('Item', total_price: 5.0, purchase_tax: 0.5)
    end

    it "#total_price" do
      expect(@receipt.total_price).to eql 15.0
    end

    it "#total_tax" do
      expect(@receipt.total_tax).to eql 1.5
    end
  end

  it "#total_price" do
    expect(@receipt.total_price).to eql 0
  end

  it "#total_tax" do
    expect(@receipt.total_tax).to eql 0
  end
end
