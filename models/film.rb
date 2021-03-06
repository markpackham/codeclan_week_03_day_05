require_relative("../db/sql_runner")

class Film
  attr_reader :id
  attr_accessor :title, :genre, :price

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @title = options["title"]
    @genre = options["genre"]
    @price = options["price"].to_i
  end

  def self.map_items(film_data)
    result = film_data.map { |film| Film.new(film) }
    return result
  end

  # Delete
  def self.delete_all()
    sql = "DELETE FROM films;"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM films
          WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  #Create
  def save()
    sql = "INSERT INTO films
        (
          title,
          genre,
          price
        )
        VALUES
        (
          $1, $2, $3
        )
        RETURNING id"
    values = [@title, @genre, @price]
    film = SqlRunner.run(sql, values).first
    @id = film["id"].to_i
  end

  #Update
  def update()
    sql = "UPDATE films SET title = $1, genre = $2, price = $3 WHERE id = $4;"
    values = [@title, @genre, @price, @id]
    SqlRunner.run(sql, values)
  end

  # Read
  def self.all()
    sql = "SELECT * FROM films;"
    films = SqlRunner.run(sql)
    return Film.map_items(films)
  end

  def self.find_id(id)
    sql = "SELECT * FROM films WHERE films.id = $1;"
    values = [id]
    films = SqlRunner.run(sql, values)
    return Film.map_items(films)
  end

  def self.find_title(title)
    sql = "SELECT * FROM films WHERE films.title = $1;"
    values = [title]
    films = SqlRunner.run(sql, values)
    return Film.map_items(films)
  end

  def self.find_genre(genre)
    sql = "SELECT * FROM films WHERE films.genre = $1;"
    values = [genre]
    films = SqlRunner.run(sql, values)
    return Film.map_items(films)
  end

  # Show all films execpt the genre you hate
  def self.not_genre(genre)
    sql = "SELECT * FROM films WHERE NOT films.genre = $1;"
    values = [genre]
    films = SqlRunner.run(sql, values)
    return Film.map_items(films)
  end

  # Average Film Price
  def self.average_price()
    sql = "SELECT AVG(films.price) FROM films;"
    films = SqlRunner.run(sql)
    return films[0]["avg"].to_i
  end

  # Total Cinema Earnings
  def self.total_earnings()
    sql = "SELECT SUM(films.price) FROM films;"
    films = SqlRunner.run(sql)
    return films[0]["sum"].to_i
  end

  def screenings()
    sql = "
        SELECT screenings.*
        FROM screenings
        INNER JOIN films
        ON screenings.film_id = films.id
        WHERE screenings.film_id = $1;
        "
    values = [@id]
    screenings = SqlRunner.run(sql, values)
    return Screening.map_items(screenings)
  end

  def customers()
    sql = "
        SELECT customers.*
        FROM customers
        INNER JOIN tickets
        ON tickets.customer_id = customers.id
        WHERE film_id = $1
        ORDER BY customers.name ASC;
        "
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return Customer.map_items(customers)
  end

  # How many customers went to see a film?
  def customers_count()
    return customers().length()
  end

  def self.cheapest_film()
    sql = "SELECT * FROM films ORDER BY films.price ASC LIMIT 1;"
    films = SqlRunner.run(sql)
    return Film.map_items(films)
  end

  def self.priciest_film()
    sql = "SELECT * FROM films ORDER BY films.price DESC LIMIT 1;"
    films = SqlRunner.run(sql)
    return Film.map_items(films)
  end
end
