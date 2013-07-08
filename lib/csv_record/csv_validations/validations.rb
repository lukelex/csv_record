require 'csv_record/csv_validations/custom_validation'
require 'csv_record/csv_validations/uniqueness_validation'
require 'csv_record/csv_validations/presence_validation'

module CsvRecord::Validations
  module ClassMethods
    [:presence, :uniqueness].each do |kind|
      validator_collection = "fields_to_validate_#{kind}"
      class_macro = "validates_#{kind}_of"
      validation_class_name = eval "CsvRecord::#{kind.to_s.capitalize}Validation"

      define_method validator_collection do
        eval "@#{validator_collection} ||= []"
      end

      define_method "add_to_#{validator_collection}" do |value|
        (eval "@#{validator_collection} ||= []") << value
      end

      define_method "__#{class_macro}__" do |*field_names|
        field_names.each do |field|
          validation_obj = validation_class_name.new field
          self.public_send "add_to_#{validator_collection}", validation_obj
        end
      end

      eval "alias :#{class_macro} :__#{class_macro}__"
    end

    def custom_validators
      @custom_validators ||= []
    end

    def validate(*methods, &block)
      @custom_validators ||= []
      methods.each do |method|
        @custom_validators << (CsvRecord::CustomValidation.new method)
      end
      @custom_validators << (CsvRecord::CustomValidation.new block) if block_given?
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
        def @errors.add attribute
          self << attribute
        end
      end

      @errors
    end

    alias :valid? :__valid__?

    private
    [:presence, :uniqueness].each do |type|
      define_method "trigger_#{type}_validations" do
        fields_to_validate = self.class.public_send "fields_to_validate_#{type}"
        fields_to_validate.each do |validator|
          validator.run_on self
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
