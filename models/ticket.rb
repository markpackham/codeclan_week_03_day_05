require_relative("../db/sql_runner")

class Ticket
  attr_reader :id
  attr_accessor :customer_id, :film_id

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @customer_id = options["customer_id"].to_i
    @film_id = options["film_id"].to_i
  end

  def self.map_items(ticket_data)
    result = ticket_data.map { |film| Ticket.new(film) }
    return result
  end

  # Delete
  def self.delete_all()
    sql = "DELETE FROM tickets;"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM tickets
          WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  # Create
  def save()
    sql = "INSERT INTO tickets
        (
          customer_id,
          film_id
        )
        VALUES
        (
          $1, $2
        )
        RETURNING id"
    values = [@customer_id, @film_id]
    ticket = SqlRunner.run(sql, values).first
    @id = ticket["id"].to_i
  end

  # Update
  def update()
    sql = "UPDATE tickets SET customer_id = $1, film_id = $2 WHERE id = $3;"
    values = [@customer_id, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  # Read
  def self.all()
    sql = "SELECT * FROM tickets;"
    tickets = SqlRunner.run(sql)
    return Ticket.map_items(tickets)
  end

  def self.find_id(id)
    sql = "SELECT * FROM tickets WHERE tickets.id = $1;"
    values = [id]
    tickets = SqlRunner.run(sql, values)
    return Ticket.map_items(tickets)
  end

  def film()
    sql = "SELECT * FROM films WHERE id = $1;"
    values = [@film_id]
    film = SqlRunner.run(sql, values).first
    return Film.new(film)
  end

  def customer()
    sql = "SELECT * FROM customers WHERE id = $1;"
    values = [@customer_id]
    customer = SqlRunner.run(sql, values).first
    return Customer.new(customer)
  end
end
