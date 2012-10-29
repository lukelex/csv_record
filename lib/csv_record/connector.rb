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

    def __parse_database_file__
      open_database_file do |csv|
        CSV.open(self.const_get('DATABASE_LOCATION_TMP'), 'w', :headers => true) do |copy|
          copy << fields
          csv.entries.each do |entry|
            new_row = yield(entry)
            copy << new_row if new_row
          end
        end
      end
      rename_database
    end

    protected

    def rename_database
      old_file = self.const_get('DATABASE_LOCATION')
      tmp_file = self.const_get('DATABASE_LOCATION_TMP')
      File.delete old_file
      File.rename(tmp_file, old_file)
    end

    alias :initialize_db_directory :__initialize_db_directory__
    alias :initialize_db :__initialize_db__
    alias :open_database_file :__open_database_file__
    alias :parse_database_file :__parse_database_file__
  end
end