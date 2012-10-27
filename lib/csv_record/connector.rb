module CsvRecord
  module Connector
    def __initialize_db_directory__
      unless Dir.exists? 'db'
        FileUtils.mkdir_p('db')
      end
    end

    def __initialize_db__
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

    def __open_database_file__(mode='r')
      CSV.open(self.const_get('DATABASE_LOCATION'), mode, :headers => true) do |csv|
        yield(csv)
      end
    end

    alias :initialize_db_directory :__initialize_db_directory__
    alias :initialize_db :__initialize_db__
    alias :open_database_file :__open_database_file__
  end
end