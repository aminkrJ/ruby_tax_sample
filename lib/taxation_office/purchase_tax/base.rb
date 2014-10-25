module TaxationOffice
  module PurchaseTax
    class Base
      def percentage
        self.class::PERCENTAGE
      end
    end
  end
end
