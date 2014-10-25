require_relative '../lib/taxation_office'

receipt = TaxationOffice::Receipt.new
$stdin.each_line do |l|
  break if l.chomp.empty?
  params = l.chomp.split(',').collect(&:strip)
  receipt.items.push TaxationOffice::Item.new(params[0].to_i, params[1], params[2])
end

tax_office = TaxationOffice::PurchaseTax::Calculator.new
tax_office.receipt = receipt
tax_office.rules << TaxationOffice::PurchaseTax::Import.new
tax_office.rules << TaxationOffice::PurchaseTax::Basic.new
tax_office.calculate :inclusive

puts "t.t: #{receipt.total_tax.round_up_05.to_s("F")} \n"
puts "t.p: #{receipt.total_price.to_s("F")}"
