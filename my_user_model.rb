require 'sqlite3'

$db_name  ="db.sql"
$tablename="user"

class Connection_db

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
        password varchar(5) NOT NULL,
        email varchar(50) NOT NULL UNIQUE 
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
    
    def to_hash
        {id: @id, firstname: @firstname, lastname: @lastname, age: @age, password: @password, email: @email}
    end

    def inspect
        query=%Q|<user id: "#{@id}", firstname: "#{@firstname}", lastname: "#{@lastname}", age: "#{@age}", password: "#{@password}", email: "#{@email}">\n|
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
        #puts query

        Connection_db.new.execute(query)
        

    end

    def self.find(user_id)
        query= <<-REQUEST
            SELECT * FROM #{$tablename} WHERE id= #{user_id}
        REQUEST

        rows=Connection_db.new.execute(query)
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

    rows=Connection_db.new.execute(query)
        if rows.any?
            rows.map do |rows|
                User.new(rows)
            end
        else
            nil
        end

    end

    def self.update(user_id, attribute, value)
        query=<<-REQUEST
            UPDATE #{$tablename}
            SET #{attribute.to_s} = '#{value}'
            WHERE id= #{user_id}

        REQUEST
        puts query
        Connection_db.new.execute(query)
    end

    def self.destroy(user_id)
        query=<<-REQUEST
            DELETE FROM #{$tablename}
            WHERE id=#{user_id};
        REQUEST
        Connection_db.new.execute(query)
    end
    
end

def _main()
    
   # User.all
   #p User.create(firstname: "peaky", lastname: "blinders", age: 70, password: "tommy", email: "shelby_inc@gmail.com")

    #p User.create(firstname: "dave", lastname: "huncho", age: 45, password: "personna", email: "nongrata@gmail.com")
end

_main()
    
