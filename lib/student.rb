class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

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
    DB[:conn].execute("DROP TABLE students")
  end

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

# Student.create(name: "Sally", grade: "10th")
  def self.create(name_grade)
    name_grade = name_grade.values
    new_studnt = Student.new(name_grade[0], name_grade[1])
    new_studnt.save
    new_studnt


  end

end


### Attributes

# Your `Student` instances should initialize with a name, grade and an optional id. The default value of the `id` argument should be set to `nil`. This is because when we create new `Student` instances, we will not assign them an `id`. That is the responsibility of the database and we will learn more about that later.
#
# `Student` attributes should have an `attr_accessor` for `name` and `grade` but only an `attr_reader` for `id`. The only place `id` can be set equal to something is inside the initialize method, via: `@id = some_id`
#
# ### The `.create_table` Method
#
# This is a class method that creates the students table. Use a heredoc to set a variable, `sql`, equal to the necessary SQL statement. Remember, the attributes of a student, `name`, `grade`, and `id`, should correspond to the column names you are creating in your students table. The `id` column should be the primary key.
#
# With your `sql` variable pointing to the correct SQL statement, you can execute that statement using the `#execute` method provided to us by the SQLite3-Ruby gem. Remember that this method is called on whatever object stores your connection to the database, in this case `DB[:conn]`.
#
# ### The `.drop_table` Method
#
# This is a class method that drops the students table. Once again, create a variable `sql`, and set it equal to the SQL statement that drops the students table. Execute that statement against the database using `DB[:conn].execute(sql)`.
#
# ### The `#save` Method
#
# This is an instance method that saves the attributes describing a given student to the students table in our database. Once again, create a variable, `sql`, and set it equal to the SQL statement that will `INSERT` the correct data into the table.
#
# Use bound paremeters to pass the given student's name and grade into the SQL statement. Remember that you don't need to insert a value for the `id` column. Because it is the primary key, the `id` column's value will be automatically assigned. **However**, at the end of your `#save` method, you do need to grab the ID of the last inserted row, i.e. the row you just inserted into the database, and assign it to the be the value of the @id attribute of the given instance.
#
# ### The `.create` Method
#
# This is a class method that uses keyword arguments. The keyword arguments are `name:` and `grade:`. Use the values of these keyword arguments to: 1) instantiate a new `Student` object with `Student.new(name, grade)` and 2) save that new student object via `student.save`. The `#create` method should return the student object that it creates.
