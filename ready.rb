require 'bigdecimal'
require 'bigdecimal/util'
require 'pry'
require 'rspec'

class BigDecimal
  def round_up_05
    (self*20).ceil.to_d/20.0
  end
end

class Collection
 include Enumerable

 attr_accessor :items

  def initialize
    @items = []
  end

  def each &block
    items.each{|item| block.call(item)}
  end

  def total_tax
    map(&:tax_amount).inject{|sum, i| sum + i}.round_up_05
  end

  def total_price
    map(&:total_price).inject{|sum, i| sum + i}
  end
end

class Item
  attr_accessor :quantity, :name, :price

  def initialize args
    args.each{|k, v| instance_variable_set("@#{k}", v) unless v.nil?}
  end

  def tax_amount
    ItemTax.new(self).calculate
  end

  def to_s
    "#{quantity}, #{name}, #{price.to_d.to_s("F")}"
  end

  def total_price
    price*quantity
  end
end

class ItemTax
  attr_accessor :item

  def initialize item
    @item = item
  end

  def calculate
    Tax.calculate_inclusively item.total_price, ImportTax.new(name: item.name), BasicTax.new(name: item.name)
  end
end

module TaxCalculation
  def calculate_inclusively after_tax, *applicable_taxes
    TaxCalculation.calculate_inclusively(after_tax, applicable_taxes) 
  end

  class TaxCalculation
    class << self
      def calculate_inclusively after_tax, applicable_taxes
        @after_tax = after_tax
        @applicable_taxes = applicable_taxes
        exact_tax_amount
      end

      private
      def before_tax
        return @after_tax if @applicable_taxes.empty?
        @after_tax/(1 + @applicable_taxes.map(&:percentage).inject{|sum,p| sum + p })
      end

      def exact_tax_amount
        @after_tax - before_tax
      end
    end
  end
end

class Tax
  extend TaxCalculation

  attr_accessor :name

  def initialize args
    args.each{|k, v| instance_variable_set("@#{k}", v) unless v.nil?}
  end

  def percentage
    return 0 if qualify_for_exemption?
    self.class::PERCENTAGE
  end
end

class ImportTax < Tax
  PERCENTAGE = 0.05

  def qualify_for_exemption?
    !name.downcase.split.include?("imported")
  end
end

class BasicTax < Tax
  PERCENTAGE = 0.1
  EXEMPTIONS = ['book', 'chocolates', 'pills', 'chocolate']

  def qualify_for_exemption?
    (name.downcase.split & EXEMPTIONS).size > 0
  end
end

RSpec.describe Item do
  subject{Item.new quantity: 1, price: 12.49, name: 'perfume'}
  it "#total_price" do
    expect(subject.total_price).to eq(12.49)
  end
  it "#to_s" do
    expect(subject.to_s).to eq("1, perfume, 12.49")
  end
end

RSpec.describe Tax do
  context "applicable for both import and basic" do
    subject{'imported perfume'}
    it ".calculate_inclusively" do
      expect(Tax.calculate_inclusively(31.29, ImportTax.new(name: subject), BasicTax.new(name: subject)).round(2)).to eql(4.08)
    end
  end
  context "applicable for only import" do
    subject{'imported book'}
    it ".calculate_inclusively" do
      expect(Tax.calculate_inclusively(31.29, ImportTax.new(name: subject), BasicTax.new(name: subject)).round(2)).to eql(1.49)
    end
  end
  context "applicable for only basic" do
    subject{'perfume'}
    it ".calculate_inclusively" do
      expect(Tax.calculate_inclusively(31.29, ImportTax.new(name: subject), BasicTax.new(name: subject)).round(2)).to eql(2.84)
    end
  end
  context "none applicable" do
    subject{'book'}
    it ".calculate_inclusively" do
      expect(Tax.calculate_inclusively(31.29, ImportTax.new(name: subject), BasicTax.new(name: subject)).round(2)).to eql(0.0)
    end
  end
end

RSpec.describe Collection do
  subject{Collection.new}
  before{subject.items << double(tax_amount: 1.67.to_d, total_price: 1.41)}
  it "#total_price" do
    expect(subject.total_price).to eq(1.41)
  end
  it "#total_tax" do
    expect(subject.total_tax).to eq(1.70)
  end
end

RSpec.describe BigDecimal do
  context "equal .05" do
    it "#round_up_05" do
      expect("5.15".to_d.round_up_05).to eq(5.15)
    end
  end

  context "> .05" do
    it "#round_up_05" do
      expect("5.16".to_d.round_up_05).to eq(5.2)
    end
  end

  context "< .05" do
    it "#round_up_05" do
      expect("5.11".to_d.round_up_05).to eq(5.15)
    end
  end
end

collection = Collection.new
$stdin.each_line do |l|
  break if l.chomp.empty?
  params = l.chomp.split(',').collect(&:strip)
  collection.items << Item.new(quantity: params[0].to_i, name: params[1], price: params[2].to_d)
end
unless collection.items.empty?
  collection.items.each do |i|
    puts "#{i.to_s} \n"
  end
  puts "s.t: #{collection.total_tax.to_s("F")} \n"
  puts "t: #{collection.total_price.to_s("F")} \n"
end
