module CsvRecord
  module Validations
    module ClassMethods
      attr_writer :fields_to_validate

      def fields_to_validate
        @fields_to_validate || []
      end

      def __validates_presence_of__(*attr_names)
        @fields_to_validate = attr_names
      end

      alias :validates_presence_of :__validates_presence_of__
    end

    module InstanceMethods
      def __valid__?
        validate_each(self.class.fields_to_validate)
        errors.empty?
      end

      def invalid?
        not self.__valid__?
      end

      def errors
        @errors || []
      end

      alias :valid? :__valid__?

      private
      def validate_each(attributes)
        attributes.each do |attribute|
          if self.public_send(attribute).nil?
            @errors = self.errors.add attribute
          end
        end
      end
    end
  end
end