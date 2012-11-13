require 'pry'
module CsvRecord
  module Validation
    attr_reader :errors, :fields_to_validate

    def __fields_to_validate_builder__(attr_names)
      @fields_to_validate = attr_names
    end

    def __validates_presence_of__(*attr_names)
      fields_to_validate_builder(attr_names)
    end

    alias :validates_presence_of :__validates_presence_of__
    alias :fields_to_validate_builder :__fields_to_validate_builder__

    module InstanceMethods

      def __valid__?
        validate_each(self.class.fields_to_validate)
      end

      alias :valid? :__valid__?

      private
      def validate_each(attritbutes)
        attritbutes.collect.none? { |attr| self.public_send(attr).nil? }
      end

    end

  end
end