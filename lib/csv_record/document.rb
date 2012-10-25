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
          CSV.open(DATABASE_LOCATION, 'wb') do |csv|
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
        CSV.open(Car::DATABASE_LOCATION, 'r', :headers => true) do |csv|
          csv.entries.map { |attributes| self.new attributes }
        end
      end
    end

    module InstanceMethods
      attr_reader :id

      def save
        Car.initialize_db
        write_object
      end

      def values
        Car.fields.map { |attribute| self.public_send(attribute) }
      end

      def attributes
        Hash[Car.fields.zip self.values]
      end

      def write_object
        calculate_id
        CSV.open(DATABASE_LOCATION, 'a') do |csv|
          csv << values
        end
        true
      end

      def calculate_id
        @id = Car.all.size + 1
      end
    end

    def self.included(receiver)
      self.const_set('DATABASE_LOCATION',"db/#{parse_caller(caller[1]).downcase}.csv")

      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end

    def self.parse_caller(at)
      /(?:(\<class\:)(\w+))/ =~ at
      $2
    end
  end
end