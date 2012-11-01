require 'csv'

module CsvRecord
  module Writer
    module ClassMethods
      def __create__(attributes={})
        instance = self.new attributes
        instance.run_before_create_callbacks
        result = instance.save
        instance.run_after_create_callbacks if result
        instance
      end

      alias :create :__create__
    end

    module InstanceMethods
      def self.included(receiver)
        receiver.send :attr_accessor, :id
      end

      def __save__
        self.new_record? ? self.append_registry : self.update_registry
      end

      def new_record?
        self.created_at.nil? || self.id.nil?
      end

      def __update_attribute__(field, value)
        self.public_send "#{field}=", value
        self.save
      end

      def __destroy__
        self.class.parse_database_file do |row|
          new_row = row
          new_row = nil if self.id == row.field('id').to_i
          new_row
        end
        empty_fields
        true
      end

      protected

      def calculate_id
        @id = self.class.count + 1
      end

      def append_registry
        self.class.initialize_db
        set_created_at
        write_object
      end

      def update_registry
        set_updated_at
        self.class.parse_database_file do |row|
          new_row = row
          new_row = self.values if self.id == row.field('id').to_i
          new_row
        end
        true
      end

      def __write_object__
        calculate_id
        self.class.open_database_file 'a' do |csv|
          csv << values
        end
        true
      end

      def empty_fields
        %w(id created_at updated_at).each do |field|
          self.public_send "#{field}=", nil
        end
      end

      alias :save :__save__
      alias :write_object :__write_object__
      alias :update_attribute :__update_attribute__
      alias :destroy :__destroy__
    end
  end
end