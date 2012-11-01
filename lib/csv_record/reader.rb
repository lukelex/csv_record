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

      def __find__(params)
        open_database_file do |csv|
          row = search_for csv, params
          self.new row.to_hash
        end
      end

      def search_for(csv, params)
        unless params.is_a? Hash
          params = params.id unless params.is_a? Integer
          csv.entries.select { |attributes| attributes['id'].to_i == params }.first
        else
          conditions = ''
          params.each_pair do |property, value|
            conditions << "attributes['#{property.to_s}'] == '#{value}'"
          end
          csv.entries.select do |attributes|
            eval conditions
          end.first
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