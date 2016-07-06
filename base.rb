require 'pg'

class Base
  def self.connection
    @@connection = PG.connect(
    host: 'localhost',
    dbname: 'contact_list_app',
    user: 'development',
    password: 'development'
    )
  end

end
