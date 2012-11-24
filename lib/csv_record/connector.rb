module CsvRecord
  module Connector
    DATABASE_FOLDER = 'db'.freeze
    APPEND_MODE = 'a'.freeze
    WRITE_MODE = 'wb'.freeze
    READ_MODE = 'r'.freeze

    def __initialize_db_directory__
      unless Dir.exists? DATABASE_FOLDER
        Dir.mkdir DATABASE_FOLDER
      end
    end

    def __initialize_db__
      __initialize_db_directory__
      unless db_initialized?
        open_database_file WRITE_MODE do |csv|
          csv << fields
        end
      end
    end

    def db_initialized?
      File.exist? self.const_get('DATABASE_LOCATION')
    end

    def __open_database_file__(mode=READ_MODE)
      __initialize_db__ if mode == READ_MODE # fix this later
      CSV.open(self.const_get('DATABASE_LOCATION'), mode, headers: true) do |csv|
        yield(csv)
      end
    end

    def __parse_database_file__
      open_database_file do |csv|
        CSV.open(self.const_get('DATABASE_LOCATION_TMP'), WRITE_MODE, headers: true) do |copy|
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