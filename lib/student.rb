require 'pry'
class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT);")
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students;")
  end

  def save
    save_sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?,?);
    SQL

    id_sql = <<-SQL
      SELECT id FROM students LIMIT 1;
    SQL

    DB[:conn].execute(save_sql, self.name, self.grade)
    @id = DB[:conn].execute(id_sql)[0][0]
  end

  def self.create(name: name,grade: grade)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end

end
