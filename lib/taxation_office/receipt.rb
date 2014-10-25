module TaxationOffice
  class Receipt
    attr_accessor :items

    def initialize
      @items = []
    end

    def total_price
      items.map(&:total_price).inject  :+
    end

    def total_tax
      items.map(&:purchase_tax).inject :+
    end
  end
end
