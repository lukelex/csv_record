module CsvRecord
  module Writer
    module ClassMethods
      def __create__(attributes={})
        instance = self.new attributes
        instance.save
        instance
      end

      alias :create :__create__
    end

    module InstanceMethods
      def self.included(receiver)
        receiver.send :attr_accessor, :id
      end

      def __save__
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

      def __write_object__
        calculate_id
        self.class.open_database_file 'a' do |csv|
          csv << values
        end
        true
      end

      alias :save :__save__
      alias :write_object :__write_object__
    end
  end
end