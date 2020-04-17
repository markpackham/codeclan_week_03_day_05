require_relative("../models/ticket")
require_relative("../models/film")
require_relative("../models/customer")

require("pry")

# Ticket.delete_all()
Film.delete_all()
Customer.delete_all()

customer1 = Customer.new({ "name" => "Hephestus", "funds" => 5000 })
customer1.save()

film1 = Film.new({ "title" => "Armitage Shanks Returns", "price" => 10 })
film1.save()

binding.pry

nil
