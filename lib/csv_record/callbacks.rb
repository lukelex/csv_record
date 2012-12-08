module CsvRecord
  module Callbacks
    CALLBACKS = [
      :after_initialize,
      :after_find,
      :before_validation,
      :after_validation,
      :before_save,
      :after_save,
      :before_create,
      :after_create,
      :before_update,
      :after_update
    ].freeze

    module ClassMethods
      CALLBACKS.each do |callback|
        define_method callback do |*args, &block|
          const_variable = "#{callback}_callbacks".upcase
          const_set(const_variable, []) unless const_defined? const_variable
          const_get(const_variable) << block if block
        end
      end

      def __where__(*args)
        results = super
        results.each &:run_after_find_callbacks
        results
      end
    end

    module InstanceMethods
      CALLBACKS.each do |callback|
        define_method "run_#{callback}_callbacks" do
          const_variable = "#{callback}_callbacks".upcase
          if self.class.const_defined? const_variable
            callbacks_collection = self.class.const_get("#{callback}_callbacks".upcase)
            callbacks_collection.each do |callback_proc|
              self.instance_eval &callback_proc
            end
          end
        end
      end

      [:build, :initialize].each do |initialize_method|
        define_method initialize_method do |*args|
          result = super(*args)
          self.run_after_initialize_callbacks
          result
        end
      end

      def valid?
        self.run_before_validation_callbacks
        is_valid = super
        self.run_after_validation_callbacks if is_valid
        is_valid
      end

      def save(*args)
        self.run_before_save_callbacks
        is_saved = super
        self.run_after_save_callbacks if is_saved
        is_saved
      end

      def append_registry
        self.run_before_create_callbacks
        is_saved = super
        self.run_after_create_callbacks if is_saved
        is_saved
      end

      def update_registry
        self.run_before_update_callbacks
        saved = super
        self.run_after_update_callbacks if saved
        saved
      end
    end

    def self.included(receiver)
      receiver.extend ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end