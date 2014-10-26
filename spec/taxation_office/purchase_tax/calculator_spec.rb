require 'spec_helper'

describe TaxationOffice::PurchaseTax::Calculator do
  before(:each) do
    @calculator = TaxationOffice::PurchaseTax::Calculator.new
  end

  it "#rules" do
    expect(@calculator.rules).to be_kind_of Array
  end

  it "#receipt" do
    expect(@calculator.receipt).to be_kind_of TaxationOffice::Receipt
  end

  context "prices are inclusive" do
    it "#method is inclusive" do
        expect(@calculator.method).to eql :inclusive
    end

    context "with empty receipt" do
      it "#calculate" do
        expect(@calculator.calculate).to eql 0
      end
    end

    context "with receipt with items" do
    end

  end
end
