cart = Cart.new
$stdin.each_line do |l|
  break if l.chomp.empty?
  params = l.chomp.split(',').collect(&:strip)
  cart.add_item Item.new(quantity: params[0].to_i, name: params[1], price: params[2])
  tax_officer = cart.item.tax_calculator
  tax_officer.add_tax_rule BasiceTax.new(cart.item)
  tax_officer.add_tax_rule ImportTax.new(cart.item)
  tax_officer.calculate :inclusive
end
unless cart.empty?
  cart.each do |i|
    puts "#{i.to_s} \n"
  end
  puts "s.t: #{cart.total_tax.to_s("F")} \n"
  puts "t: #{cart.total_price.to_s("F")} \n"
end
