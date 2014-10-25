module TaxationOffice
  class Item
    attr_accessor :quantity, :name, :price, :purchase_tax

    def initialize price, quantity = nil, name = nil
      @price    = price.to_d
      @quantity = quantity
      @name     = name
    end

    def price=(price)
      @price = price.to_d
    end

    def quantity
      @quantity ||= 1
    end

    def to_s
      "#{quantity}, #{name}, #{price.round(2).to_s("F")}"
    end

    def total_price
      price*quantity
    end
  end
end
