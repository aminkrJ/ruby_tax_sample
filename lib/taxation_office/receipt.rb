module TaxationOffice
  class Receipt
    attr_accessor :items

    def initialize
      @items = []
    end

    def total_price
      return 0 if items.empty?
      items.map(&:total_price).inject  :+
    end

    def total_tax
      return 0 if items.empty?
      items.map(&:purchase_tax).inject :+
    end
  end
end
