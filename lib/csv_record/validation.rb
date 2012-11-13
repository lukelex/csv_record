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

      def validate_each(attritbutes)
        attritbutes.collect.none? { |attr| self.public_send(attr).nil? }
      end

      def __valid__?
        validate_each(self.class.fields_to_validate)
      end

      alias :valid? :__valid__?

      private
      # extract values from attributes in order to organize, ex: {:attribute => :name, :value => nil}
      def extract_value(attr)
        value = {}
        value[attr] = self.public_send(attr)
        value
      end
    end

    private
    def _merge_attributes(attr_names)
      options = attr_names.extract_options!
      options.merge(:attributes => attr_names.flatten)
    end
  end
end