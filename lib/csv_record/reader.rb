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

      def count
        open_database_file do |csv|
          csv.entries.inject(0) { |s, n| s+1 }
        end
      end

      def __find__(param)
        param = param.id unless param.is_a? Integer
        open_database_file do |csv|
          row = csv.entries.select { |attributes| attributes['id'] == param.to_s }.first
          self.new row.to_hash
        end
      end

      alias :find :__find__
    end

    module InstanceMethods
      def __values__
        self.class.fields.map { |attribute| self.public_send(attribute) }
      end

      def __attributes__
        Hash[self.class.fields.zip self.values]
      end

      alias :attributes :__attributes__
      alias :values :__values__
    end
  end
end