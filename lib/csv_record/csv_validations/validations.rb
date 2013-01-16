require 'csv_record/csv_validations/validation'

module CsvRecord::Validations
  module ClassMethods
    [:presence, :uniqueness].each do |kind|
      define_method "fields_to_validate_#{kind}" do
        eval "@fields_to_validate_#{kind} || []"
      end

      define_method "__validates_#{kind}_of__" do |*attr_names|
        eval "@fields_to_validate_#{kind} = attr_names"
      end

      eval "alias :validates_#{kind}_of :__validates_#{kind}_of__"
    end

    def custom_validators
      @custom_validators ||= []
    end

    def validate(*methods, &block)
      @custom_validators ||= []
      methods.each do |method|
        @custom_validators << (CsvRecord::Validation.new method)
      end
      @custom_validators << (CsvRecord::Validation.new block) if block_given?
    end
  end

  module InstanceMethods
    def __valid__?
      trigger_presence_validations
      trigger_uniqueness_validations
      trigger_custom_validations
      errors.empty?
    end

    def invalid?
      not self.__valid__?
    end

    def errors
      unless @errors
        @errors = []
        def @errors.add(attribute)
          self << attribute
        end
      end

      @errors
    end

    alias :valid? :__valid__?

    private
    def trigger_presence_validations
      self.class.fields_to_validate_presence.each do |attribute|
        if self.public_send(attribute).nil?
          self.errors.add attribute
        end
      end
    end

    def trigger_uniqueness_validations
      self.class.fields_to_validate_uniqueness.each do |attribute|
        condition = {}
        condition[attribute] = self.public_send attribute
        records = self.class.__where__ condition
        if records.any? { |record| record != self }
          self.errors.add attribute
        end
      end
    end

    def trigger_custom_validations
      self.class.custom_validators.each do |validator|
        validator.run_on self
      end
    end
  end
end