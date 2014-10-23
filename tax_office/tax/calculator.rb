module TaxOffice
  module Tax
    class Calculator
      attr_accessor :rules, :receipt, :method, :item
      attr_reader :total

      def initialize receipt = [], method = nil
        @receipt    = receipt
        @method     = method
        @rules      = []
      end

      def calculate(method = nil)
        return "specify method :inclusive | :exclusive" unless method
        return 0 if receipt.empty?
        receipt.each do |item| {
          c = Calculator.new
          c.item = item
          c.calculate method
        }
        send method.to_sym
      end

      private
      def exclusive
      end

      def inclusive
        after - before
      end

      def before
        item.total_price if method == :exclusive
        after/(rules.map(&:percentage).inject{|sum, p| p + sum} + 1)
      end

      def after
        item.total_price if method == :inclusive
      end
    end
  end
end
