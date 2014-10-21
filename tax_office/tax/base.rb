module TaxOffice
  module Tax
    class Base
      # method
      # :inclusive | :exclusive
      # type
      # :fixed | :percentage
      attr_accessor :item

      def initialize(item)
        @item = item
      end

      def percentage
        self.class::PERCENTAGE
      end
    end
  end
end
