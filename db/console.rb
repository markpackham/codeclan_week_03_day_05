require_relative("../models/ticket")
require_relative("../models/film")
require_relative("../models/customer")

require("pry")

Ticket.delete_all()
Film.delete_all()
Customer.delete_all()

customer1 = Customer.new({ "name" => "Hephestus", "funds" => 1000 })
customer2 = Customer.new({ "name" => "Malachi", "funds" => 2000 })
customer3 = Customer.new({ "name" => "Plutarch", "funds" => 3000 })
customer4 = Customer.new({ "name" => "Vigano", "funds" => 4000 })
customer5 = Customer.new({ "name" => "Torquemada", "funds" => 5000 })
customer6 = Customer.new({ "name" => "Derek", "funds" => 6000 })
customer1.save()
customer2.save()
customer3.save()
customer4.save()
customer5.save()
customer6.save()

film1 = Film.new({ "title" => "Armitage Shanks Returns", "price" => 10 })
film2 = Film.new({ "title" => "One Man And His Flannel", "price" => 20 })
film3 = Film.new({ "title" => "Cheeky Chappy Misappropriates Penny-farthing", "price" => 30 })
film1.save()
film2.save()
film3.save()

ticket1 = Ticket.new({ "customer_id" => 1, "film_id" => 1 })
ticket2 = Ticket.new({ "customer_id" => 2, "film_id" => 1 })
ticket3 = Ticket.new({ "customer_id" => 3, "film_id" => 2 })
ticket4 = Ticket.new({ "customer_id" => 4, "film_id" => 2 })
ticket5 = Ticket.new({ "customer_id" => 5, "film_id" => 3 })
ticket6 = Ticket.new({ "customer_id" => 6, "film_id" => 3 })
ticket1.save()
ticket2.save()
ticket3.save()
ticket4.save()
ticket5.save()
ticket6.save()

binding.pry

nil
