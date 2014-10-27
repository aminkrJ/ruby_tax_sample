require 'spec_helper'

describe TaxationOffice::PurchaseTax::Calculator do
  before(:each) do
    @calculator = TaxationOffice::PurchaseTax::Calculator.new
  end

  it "initialize" do
    expect(@calculator.rules).to be_kind_of Array
    expect(@calculator.receipt).to be_kind_of TaxationOffice::Receipt
  end

  it "#calculate either inclusive or exclusive for empty receipt" do
    expect(@calculator.calculate).to eql 0
  end

  context "prices are inclusive" do
    let(:item_1){double total_price: 12}

    it "#method is inclusive" do
      expect(@calculator.method).to eql :inclusive
    end

    context "without rules" do
      it "#calculate" do
        @calculator.receipt.items.push item_1

        allow(item_1).to receive(:purchase_tax=).with(0.0)
        @calculator.calculate
      end

      it "#total_tax_percentage" do
        expect(@calculator.total_tax_percentage).to eql(0)
      end
    end

    context "with rules" do
      let(:rule_1){double percentage: 0.1}
      let(:rule_2){double percentage: 0.05}

      it "#calculate" do
        @calculator.receipt.items.push item_1
        @calculator.rules.push rule_1

        allow(item_1).to receive(:purchase_tax=).with(1.09.to_d.round_up_05)
        @calculator.calculate
      end

      it "#total_tax_percentage" do
        @calculator.rules = [rule_1, rule_2]
        expect(@calculator.total_tax_percentage).to eql(0.15)
      end
    end
  end
end
