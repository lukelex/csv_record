module CsvRecord
  module Associations
    def belongs_to(klass)
      klass_name = klass.to_s
      def klass_name.constantize
        self.split('_').map {|w| w.capitalize}.join
      end

      const_klass = const_get klass_name.constantize

      self.class_eval do
        define_method klass do
          const_klass.find self.id
        end
        define_method "#{klass}=" do |value|
          self.send "#{klass}_id=", value.to_param
        end
        self.send :attr_writer, "#{klass}_id"
        define_method "#{klass}_id" do
          @id.to_i
        end
      end
    end
  end
end