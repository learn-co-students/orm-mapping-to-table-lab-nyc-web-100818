class Student

  attr_accessor :name, :grade, :new_student
  attr_reader :id

  def initialize(name, grade, id = nil)
    # @student = {}
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
      SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
      SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?);
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT id FROM students WHERE name = '#{@name}'").flatten[0]
  end

  def self.create(student)
    new_student = Student.new(student[:name], student[:grade])
    new_student.save
    new_student
  end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

end
