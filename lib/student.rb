class Student
  attr_accessor :name, :grade, :id

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new
    student.id=row[0]
    student.name=row[1]
    student.grade=row[2]
    student
  end


  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
      ;
    SQL

  result = DB[:conn].execute(sql)
  result.map {|student_record| self.new_from_db(student_record)}
  end

  def self.find_by_name(name)
    # formulate slq query
    sql = <<-SQL
    SELECT  *
    FROM    students
    WHERE  name = ?
    ;
    SQL

    # apply the query, get back
    result = DB[:conn].execute(sql,name)[0]
    student = Student.new
    student.id = result[0]
    student.name = result[1]
    student.grade = result[2]
    student
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute('SELECT last_insert_rowid() FROM students')[0][0]
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = 'DROP TABLE IF EXISTS students'
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 9
      ;
    SQL

    result = DB[:conn].execute(sql)
    result.map {|student_record| self.new_from_db(student_record)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade <12
      ;
    SQL
    result = DB[:conn].execute(sql)
    result.map {|student_record| self.new_from_db(student_record)}
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade <11
    LIMIT ?
    ;
    SQL
  result = DB[:conn].execute(sql,num)
  result.map {|student_record| self.new_from_db(student_record)}

  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade <11
    LIMIT 1
    ;
    SQL
    result = DB[:conn].execute(sql)
    result.map {|student_record| self.new_from_db(student_record)}[0]
  end

  def self.all_students_in_grade_X(num)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = ?
    ;
    SQL
    result = DB[:conn].execute(sql,num)
    result.map {|student_record| self.new_from_db(student_record)}
  end



end
