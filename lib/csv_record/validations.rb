module CsvRecord
  module Validations
    module ClassMethods
      def fields_to_validate_presence
        @fields_to_validate_presence || []
      end

      def fields_to_validate_uniqueness
        @fields_to_validate_uniqueness || []
      end

      def __validates_presence_of__(*attr_names)
        @fields_to_validate_presence = attr_names
      end

      def __validates_uniqueness_of__(*attr_names)
        @fields_to_validate_uniqueness = attr_names
      end

      alias :validates_presence_of :__validates_presence_of__
      alias :validates_uniqueness_of :__validates_uniqueness_of__
    end

    module InstanceMethods
      def __valid__?
        trigger_presence_validations
        trigger_uniqueness_validations
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
      def trigger_presence_validations
        self.class.fields_to_validate_presence.each do |attribute|
          if self.public_send(attribute).nil?
            @errors = self.errors.add attribute
          end
        end
      end

      def trigger_uniqueness_validations
        self.class.fields_to_validate_uniqueness.each do |attribute|
          condition = {}
          condition[attribute] = self.public_send attribute
          records = self.class.__where__ condition
          if records.any? { |record| record != self }
            @errors = self.errors.add attribute
          end
        end
      end
    end
  end
end