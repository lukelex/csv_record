module CsvRecord
  module Callbacks
    CALLBACKS = [
      :after_initialize,
      :before_validation,
      :after_validation,
      :before_create,
      :before_save,
      :after_create,
      :after_save
    ].freeze

    module ClassMethods
      CALLBACKS.each do |callback|
        define_method callback do |*args, &block|
          const_variable = "#{callback}_callbacks".upcase
          const_set(const_variable, []) unless const_defined? const_variable
          const_get(const_variable) << block if block
        end
      end
    end

    module InstanceMethods
      CALLBACKS.each do |callback|
        define_method "run_#{callback}_callbacks" do
          const_variable = "#{callback}_callbacks".upcase
          if self.class.const_defined? const_variable
            callbacks_collection = self.class.const_get("#{callback}_callbacks".upcase)
            callbacks_collection.each do |callback_proc|
              callback_proc.call self
            end
          end
        end
      end

      def valid?
        self.run_before_validation_callbacks
        is_valid = super
        self.run_after_validation_callbacks if is_valid
        is_valid
      end
    end

    def self.included(receiver)
      receiver.extend ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end