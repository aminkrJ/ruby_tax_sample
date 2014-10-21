module TaxOffice
  class Cart
    attr_accessor :items

    def initialize
    end

    def add_item item
      items << item
      self
    end

    def total_price
    end

    def total_tax
    end
  end
end
