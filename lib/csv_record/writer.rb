module CsvRecord
  module Writer
    module ClassMethods
      def create(attributes={})
        instance = self.new attributes
        instance.save
        instance
      end
    end

    module InstanceMethods
      attr_reader :id

      def save
        Car.initialize_db
        set_creation_time
        write_object
        @new_record = false
      end

      def new_record?
        @new_record.nil? ? true : @new_record
      end

      protected

      def calculate_id
        @id = Car.all.size + 1
      end

      def write_object
        calculate_id
        self.class.open_database_file 'a' do |csv|
          csv << values
        end
        true
      end
    end
  end
end