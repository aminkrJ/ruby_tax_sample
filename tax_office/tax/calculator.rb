module TaxOffice
  module Tax
    class Calculator
      attr_accessor :tax_collection, :item, :method

      def initialize item, method = nil
        @item       = item
        @method     = method
        @tax_collection = []
      end

      def add_tax_rule tax
        tax_collection << tax
      end

      def calculate(method = nil)
        return "specify method :inclusive | :exclusive" unless method
        return 0 if tax_collection.empty?
        send method.to_s
      end

      private
      def exclusive
      end

      def inclusive
        after - before
      end

      def before
        item.total_price if method == :exclusive
        after/(tax_collection.map(&:percentage).inject{|sum, p| p + sum} + 1)
      end

      def after
        item.total_price if method == :inclusive
      end
    end
  end
end
