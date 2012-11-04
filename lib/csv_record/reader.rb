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
        (__where__ :id => param).first
      end

      def __where__(params)
        open_database_file do |csv|
          rows = search_for csv, params
          rows.map { |row| self.new row.to_hash }
        end
      end

      def search_for(csv, params)
        conditions = handle_params params
        csv.entries.select do |attributes|
          eval conditions
        end
      end

      def handle_params(params)
        conditions = ''
        index = 0
        params.each_pair do |property, value|
          conditions << "attributes['#{property}'] == '#{value}'"
          conditions << ' && ' if (params.size > 1) && (index != params.size - 1)
          index += 1
        end
        conditions
      end

      def method_missing(meth, *args, &block)
        if meth.to_s =~ /^find_by_(.+)$/
          dynamic_finder $1, *args, &block
        else
          super # You *must* call super if you don't handle the
                # method, otherwise you'll mess up Ruby's method
                # lookup.
        end
      end

      alias :fields :__fields__
      alias :find :__find__
      alias :count :__count__
      alias :where :__where__
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