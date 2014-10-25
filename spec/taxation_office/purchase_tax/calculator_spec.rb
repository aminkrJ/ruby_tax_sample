require 'spec_helper'

describe TaxationOffice::PurchaseTax::Calculator do
  before(:each) do
    @calculator = TaxationOffice::PurchaseTax::Calculator.new
    receipt = Receipt.new
    receipts.items.push instance_double('Item', price: 12.50)
    receipts.items.push instance_double('Item', price: 10)
    @calculator.receipt = receipt
    import_rule = instance_double('Import')
    basic_rule  = instance_double('Basic')
    allow(import_rule).to_receive(:percentage).and_return(10)
    allow(basic_rule).to_receive(:percentage).and_return(5)
    @calculator.rules.push import_rule
    @calculator.rules.push basic_rule
  end

  it "#receipt" do
    expect(@calculator.receipt).to be_kind_of  TaxationOffice::Receipt
  end

  it "#rules" do
    expect(@calculator.rules).to be_kind_of Array
  end

  context "prices are inclusive" do
    it "#calculate" do
      expect(@claculator.calculate).to eql
    end
  end

  context "prices are exclusive" do
  end
end
