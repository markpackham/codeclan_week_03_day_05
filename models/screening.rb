require_relative("../db/sql_runner")

class Screening
  attr_reader :id
  attr_accessor :film_id, :time

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @film_id = options["film_id"].to_i
    @time = options["time"]
  end

  def self.map_items(screening_data)
    result = screening_data.map { |screening| Screening.new(screening) }
    return result
  end

  # Delete
  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM screenings
          WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  # Create
  def save()
    sql = "INSERT INTO screenings
        (
          film_id,
          time
        )
        VALUES
        (
          $1, $2
        )
        RETURNING id"
    values = [@film_id, @time]
    screening = SqlRunner.run(sql, values).first
    @id = screening["id"].to_i
  end

  # Update
  def update()
    sql = "UPDATE screenings SET film_id = $1, time = $2 WHERE id = $3"
    values = [@film_id, @time, @id]
    SqlRunner.run(sql, values)
  end

  # Read
  def self.all()
    sql = "SELECT * FROM screenings"
    screenings = SqlRunner.run(sql)
    return Screening.map_items(screenings)
  end

  def film()
    sql = "SELECT * FROM films WHERE id = $1"
    values = [@film_id]
    film = SqlRunner.run(sql, values).first
    return Film.new(film)
  end
end
