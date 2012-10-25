module CsvRecord

  # This is the base module for all domain objects that need to be persisted to
  # the database.
  module Document
    module ClassMethods
    end

    module InstanceMethods
      attr_accessor :id

      def save
        create_db_file
        write_object
      end

      def create_db_file
        unless File.exists?(DATABASE_LOCATION)
          FileUtils.mkdir_p('db')
        end
      end

      def fields
        self.class.instance_methods(false).select { |m| m.to_s !~ /=$/ }
      end

      def values
        self.fields.map { |attribute| self.public_send(attribute) }
      end

      def attributes
        Hash[self.fields.zip self.values]
      end

      def db_initialized?(csv)
        !csv.lineno.zero?
      end

      def write_object
        CSV.open(DATABASE_LOCATION, 'wb', :col_sep => ',') do |csv|
          csv << fields unless db_initialized? csv
          csv << values
        end
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