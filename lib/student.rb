require 'pry'
class Student

  attr_accessor :name, :grade
  attr_reader :id

  @@all = []

    def initialize(name, grade, id = nil)
      @name = name
      @grade = grade
      @id = id
      @@all << self
    end

    def self.all
      @@all
    end

    def self.create_table
      sql =  <<-SQL 
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        grade TEXT
        )
        SQL
    DB[:conn].execute(sql)
    end

    def self.drop_table
      sql =  <<-SQL 
      DROP TABLE IF EXISTS students
      SQL
      DB[:conn].execute(sql)
    end

    def save
      sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL
 
    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end

    # wrap code used above to create a new Student instance &save it.
    def self.create(name:, grade:)
      student = Student.new(name, grade)
      student.save #persist Student instance to DB
      student
    end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  binding.pry
end
