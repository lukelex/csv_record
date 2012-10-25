require 'csv_record/writer'

module CsvRecord

  # This is the base module for all domain objects that need to be persisted to
  # the database.
  module Document
    module ClassMethods
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
        File.exist? DATABASE_LOCATION
      end

      def fields
        instance_methods(false).select { |m| m.to_s !~ /=$/ }
      end

      def all
        open_database_file do |csv|
          csv.entries.map { |attributes| self.new attributes }
        end
      end

      def open_database_file(mode='r')
        CSV.open(Car::DATABASE_LOCATION, mode, :headers => true) do |csv|
          yield(csv)
        end
      end
    end

    def values
      Car.fields.map { |attribute| self.public_send(attribute) }
    end

    def attributes
      Hash[Car.fields.zip self.values]
    end

    def self.included(receiver)
      self.const_set('DATABASE_LOCATION',"db/#{parse_caller(caller[1]).downcase}.csv")

      receiver.extend         ClassMethods
      receiver.extend         CsvRecord::Writer::ClassMethods
      receiver.send :include, CsvRecord::Writer::InstanceMethods
    end

    def self.parse_caller(at)
      /(?:(\<class\:)(\w+))/ =~ at
      $2
    end
  end
end