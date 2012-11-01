module CsvRecord
  module Reader
    module ClassMethods
      def __fields__
        instance_methods(false).select { |m| m.to_s !~ /=$/ }
      end

      def all
        open_database_file do |csv|
          csv.entries.map { |attributes| self.new attributes }
        end
      end

      def first
        all.first
      end

      def last
        all.last
      end

      def __count__
        open_database_file do |csv|
          csv.entries.size
        end
      end

      def __find__(param)
        param = param.id unless param.is_a? Integer
        open_database_file do |csv|
          row = csv.entries.select { |attributes| attributes['id'].to_i == param }.first
          self.new row.to_hash
        end
      end

      alias :fields :__fields__
      alias :find :__find__
      alias :count :__count__
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