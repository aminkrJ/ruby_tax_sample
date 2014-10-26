module TaxationOffice
  module PurchaseTax
    class Calculator
      attr_accessor :rules, :receipt, :method

      def initialize
        @receipt = Receipt.new
        @rules   = []
      end

      def method
        @method ||= :inclusive
      end

      def calculate
        return 0 if receipt.items.empty?
        receipt.items.each do |item|
          @item = item
          item.purchase_tax = calculate_for_each
        end
      end

      private
      def calculate_for_each
        send method
      end

      def exclusive
      end

      def inclusive
        after - before
      end

      def before
        @item.total_price if method == :exclusive
        after/(rules.map(&:percentage).inject(:+) + 1)
      end

      def after
        @item.total_price if method == :inclusive
      end
    end
  end
end
