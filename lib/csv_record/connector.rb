# frozen_string_literal: true

module CsvRecord::Connector
  APPEND_MODE = 'a'.freeze
  WRITE_MODE = 'wb'.freeze
  READ_MODE = 'r'.freeze

  # Return the folder where the archive will be stored.
  def self.database_folder
    root_folder =  ENV['CSV_RECORD_ARCHIVE_PATH'] || "."
    return File.join( root_folder, 'db')
  end

  # Checks wheter the database directory exists
  def __initialize_db_directory__
    unless Dir.exist?(CsvRecord::Connector.database_folder)
      Dir.mkdir CsvRecord::Connector.database_folder
    end
  end

  # Initialize the database file with its headers
  def __initialize_db__
    __initialize_db_directory__
    unless db_initialized?
      open_database_file(WRITE_MODE) do |csv|
        csv << doppelganger_fields
      end
    end
  end

  # Checks wheter the database file exists
  def db_initialized?
    File.exist? self.const_get('DATABASE_LOCATION')
  end

  # Open the database file
  # Params:
  # +mode+:: the operation mode (defaults to READ_MODE)
  def __open_database_file__(mode=READ_MODE)
    __initialize_db__ if mode == READ_MODE # fix this later
    db_location = self.const_get('DATABASE_LOCATION')
    CSV.open(db_location, mode, headers: true) do |csv|
      yield csv
    end
  end

  # Creates a modified copy of the database file with the new data and then replaces the original
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

  private

  # Rename the TMP database file to replace the original
  def rename_database
    old_file = self.const_get 'DATABASE_LOCATION'
    tmp_file = self.const_get 'DATABASE_LOCATION_TMP'
    while not File.exist?(old_file) ; sleep(10) ; end
    File.delete old_file
    File.rename tmp_file, old_file
  end

  alias :initialize_db_directory :__initialize_db_directory__
  alias :initialize_db :__initialize_db__
  alias :open_database_file :__open_database_file__
  alias :parse_database_file :__parse_database_file__
end
