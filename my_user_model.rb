require 'sqlite3'

$db_name  ="db.sql"
$tablename="user"

class Connection

    def new 
        @db = nil
    end

    def get_connection
        if @db==nil
            @db = SQLite3::Database.new($db_name)
            creatdb
        end
        @db
    end

    def creatdb
        rows=self.get_connection().execute <<-SQL    
        CREATE TABLE IF NOT EXISTS #{$tablename} (
        id INTEGER PRIMARY KEY,
        firstname varchar(50),
        lastname varchar(50),
        age int,
        password varchar(5),
        email varchar(50)
    );
    SQL
    end

    def execute(query)
        self.get_connection().execute(query)
    end
end

class User
    attr_accessor :id, :firstname, :lastname, :age, :password, :email

    def initialize(array)
        @id       =array[0]
        @firstname=array[1]
        @lastname =array[2]
        @age      =array[3]
        @password =array[4]
        @email    =array[5]
    end
    
    def inspect
        %Q|<user id: "#{@id}", firstname: "#{@firstname}", lastname: "#{@lastname}", age: "#{@age}", password: "#{@password}", email: "#{@email}">|
    end

    def self.create(user_info)
        query=<<-REQUEST
        INSERT INTO #{$tablename} (firstname, lastname, age, password, email)
        VALUES ("#{user_info[:firstname]}", 
        "#{user_info[:lastname]}", 
        "#{user_info[:age]}", 
        "#{user_info[:password]}",        
        "#{user_info[:email]}");
        REQUEST
        puts query

        Connection.new.execute(query)
    end

    def self.find(user_id)
        query= <<-REQUEST
            SELECT * FROM #{$tablename} WHERE id= #{user_id}
        REQUEST

        rows=Connection.new.execute(query)
        if rows.any?
            User.new(rows[0])
        else
            nil
        end

    end

    def self.all
        query= <<-REQUEST
        SELECT * FROM #{$tablename} 
    REQUEST

    rows=Connection.new.execute(query)
    if rows.any?
        rows.collect do |row|  
            User.new(rows)
        end
    else
         []
    end

    end

    def self.update(user_id, attribute, value)
        query=<<-REQUEST
            UPDATE #{$tablename}
            SET #{attribute.to_s} = '#{value}'
            WHERE id= #{user_id}

        REQUEST
        puts query
        Connection.new.execute(query)
    end

    def self.destroy(user_id)
        query=<<-REQUEST 
            DELETE FROM #{$tablename}
            WHERE id= #{user_id};
        REQUEST

        Connection.new.execute(query)
    end
    
end

def _main()
    p User.destroy(1)
   p User.find(1)
   # p User.create(firstname: "Ouatedem", lastname: "Yvan", age: 25, password: "gigs", email: "ouateedemloic@gmail.com")
end

_main()
    
