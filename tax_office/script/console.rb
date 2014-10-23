receipt = Receipt.new
$stdin.each_line do |l|
  break if l.chomp.empty?
  params = l.chomp.split(',').collect(&:strip)
  receipt.push Item.new(quantity: params[0].to_i, name: params[1], price: params[2])
end

tax_office = TaxOffice::Tax::Calculator.new receipt
tax_office.rules << TaxOffice::Tax::Import.new
tax_office.rules << TaxOffice::Tax::Basic.new
tax_office.calculate

puts "t.t: #{tax_office.total} \n"
puts "t.p: #{receipt.total_price}"
