module CsvRecord
  module Connector
    def initialize_db_directory
      unless Dir.exists? 'db'
        FileUtils.mkdir_p('db')
      end
    end

    def initialize_db
      initialize_db_directory
      unless db_initialized?
        open_database_file 'wb' do |csv|
          csv << fields
        end
      end
    end

    def db_initialized?
      File.exist? self.const_get('DATABASE_LOCATION')
    end

    def open_database_file(mode='r')
      CSV.open(self.const_get('DATABASE_LOCATION'), mode, :headers => true) do |csv|
        yield(csv)
      end
    end
  end
end