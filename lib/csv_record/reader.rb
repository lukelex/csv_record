module CsvRecord
  module Reader
    module ClassMethods
      def fields
        instance_methods(false).select { |m| m.to_s !~ /=$/ }
      end

      def all
        open_database_file do |csv|
          csv.entries.map { |attributes| self.new attributes }
        end
      end

      def find(param)
        param = param.id unless param.is_a? Integer
        open_database_file do |csv|
          csv.entries.select { |attributes| attributes['id'] == param.to_s }.first
        end
      end
    end

    module InstanceMethods
      def values
        Car.fields.map { |attribute| self.public_send(attribute) }
      end

      def attributes
        Hash[Car.fields.zip self.values]
      end
    end
  end
end