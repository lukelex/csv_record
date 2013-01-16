module CsvRecord
  module Callbacks
    CALLBACK_TYPES = [
      :after_initialize,
      :after_find,
      :before_validation,
      :after_validation,
      :before_save,
      :after_save,
      :after_destroy,
      :before_destroy,
      :before_create,
      :after_create,
      :before_update,
      :after_update
    ].freeze

    module ClassMethods
      CALLBACK_TYPES.each do |callback_type|
        define_method callback_type do |*args, &block|
          const_variable = "#{callback_type}_callbacks".upcase
          const_set(const_variable, []) unless const_defined? const_variable
          if block
            const_get(const_variable) << (CsvRecord::Callback.new callback_type, block)
          end
        end
      end

      def __where__(*args)
        results = super
        results.each &:run_after_find_callbacks
        results
      end
    end

    module InstanceMethods
      CALLBACK_TYPES.each do |callback|
        define_method "run_#{callback}_callbacks" do
          const_variable = "#{callback}_callbacks".upcase
          if self.class.const_defined? const_variable
            callbacks_collection = self.class.const_get(const_variable)
            callbacks_collection.each do |callback|
              callback.run_on(self)
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

      def destroy
        self.run_before_destroy_callbacks
        is_destroyed = super
        self.run_after_destroy_callbacks if is_destroyed
        is_destroyed
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
        self.run_after_destroy_callbacks if saved
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