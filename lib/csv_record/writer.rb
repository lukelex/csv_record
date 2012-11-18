module CsvRecord
  module Writer
    module ClassMethods
      def __create__(attributes={})
        instance = self.build attributes
        instance.run_before_create_callbacks
        result = instance.save
        instance.run_after_create_callbacks if result
        instance
      end

      [:attr_accessor, :attr_writer].each do |custom_accessor|
        define_method custom_accessor do |*args|
          @relevant_instance_variables ||= []
          args.each { |arg| @relevant_instance_variables << arg }
          super *args
        end
      end

      alias :create :__create__
    end

    module InstanceMethods
      def self.included(receiver)
        receiver.send :attr_accessor, :id
      end

      def __save__
        if self.valid?
          self.new_record? ? self.append_registry : self.update_registry
        else
          false
        end
      end

      def valid?

      end

      def new_record?
        self.created_at.nil? || self.id.nil?
      end

      def __update_attribute__(field, value)
        self.public_send "#{field}=", value
        self.save
      end

      def __update_attributes__(params={})
        params.each do |field, value|
          self.public_send "#{field}=", value
        end
        self.save
      end

      def __destroy__
        self.class.parse_database_file do |row|
          new_row = row
          new_row = nil if self.id.to_i == row.field('id').to_i
          new_row
        end
        empty_fields
        true
      end

      protected

      def calculate_id
        @id = self.class.count + 1
        # if self.respond_to? :jedi_order_id
        #   p "#{self.class} -> #{@id} -> #{self.jedi_order_id}"
        # end
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
          new_row = self.values if self.id.to_i == row.field('id').to_i
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
      alias :update_attributes :__update_attributes__
    end
  end
end