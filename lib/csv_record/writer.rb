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
      def self.included(receiver)
        receiver.send :attr_accessor, :id
      end

      def save
        Car.initialize_db
        set_created_at
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