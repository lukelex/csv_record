module CsvRecord::Writer
  module InstanceMethods
    def self.included(receiver)
      receiver.send :attr_accessor, :id
    end

    def __save__(validate=true)
      if (not validate) || self.valid?
        self.new_record? ? self.append_registry : self.update_registry
      else
        false
      end
    end

    def new_record?
      self.created_at.nil? || self.id.nil?
    end

    def __update_attribute__(field, value)
      self.public_send "#{field}=", value
      self.save false
    end

    def __update_attributes__(params={validate: true})
      validate = params[:validate]
      params.delete(:validate)

      params.each do |field, value|
        self.public_send "#{field}=", value
      end

      yield self if block_given?

      self.save validate
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
    end

    def append_registry
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
      self.class.open_database_file CsvRecord::Connector::APPEND_MODE do |csv|
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