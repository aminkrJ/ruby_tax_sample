module TaxOffice
  class Item
    attr_accessor :quantity, :name, :price, :calculator

    def initialize quantity, name, price
      @quantity = quantity
      @price    = price.to_d
      @name     = name
    end

    def tax_calculator
      @calculator ||= Tax::Calculator.new self
    end

    def to_s
      "#{quantity}, #{name}, #{price.to_s("F")}"
    end

    def total_price
      price*quantity
    end
  end
end
