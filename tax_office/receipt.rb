module TaxOffice
  class Receipt
    include Enumerable

    attr_accessor :items

    def initialize
      @items = []
    end

    def each &block
      items.each{|i| block.call i}
    end
  end
end
