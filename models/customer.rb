require_relative("../db/sql_runner")

class Customer
  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @name = options["name"]
    @funds = options["funds"].to_i
  end

  def self.map_items(customer_data)
    result = customer_data.map { |customer| Customer.new(customer) }
    return result
  end

  # Delete
  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM customers
          WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  # Create
  def save()
    sql = "INSERT INTO customers
        (
          name,
          funds
        )
        VALUES
        (
          $1, $2
        )
        RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values).first
    @id = customer["id"].to_i
  end

  # Update
  def update()
    sql = "UPDATE customers SET name = $1, funds = $2 WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  # Read
  def self.all()
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql)
    return Customer.map_items(customers)
  end

  def films()
    sql = "
        SELECT films.*
        FROM films
        INNER JOIN tickets
        ON tickets.film_id = films.id
        WHERE customer_id = $1
        ORDER BY films.title ASC;
        "
    values = [@id]
    films = SqlRunner.run(sql, values)
    return Film.map_items(films)
  end
end
