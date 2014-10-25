require 'spec_helper'

describe TaxationOffice::Item do
  before(:each) do
    @item = TaxationOffice::Item.new 10
  end

  it "#price must be decimal" do
    expect(@item.price).to be_kind_of BigDecimal
  end

  it "#quantity must be 1" do
    expect(@item.quantity).to eql 1
  end

  it "#total_price" do
    expect(@item.total_price).to eql 10
    @item.quantity = 2
    expect(@item.total_price).to eql 20
  end

  it "#to_s" do
    expect(@item.to_s).to eql "1, , 10.0"
  end
end
