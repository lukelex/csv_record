module CsvRecord::Writer
  module ClassMethods
    def __create__(attributes={})
      instance = build attributes
      yield instance if block_given?
      instance.save
      instance
    end

    [:attr_accessor, :attr_writer].each do |custom_accessor|
      define_method custom_accessor do |*attributes|
        attributes.each do |attribute|
          unless fields.has_name? attribute
            fields << CsvRecord::Field.new(attribute)
          end
        end
        super(*attributes)
      end
    end

    def store_as(name)
      @table_name = name.to_s.underscore.pluralize
      redefine_database_location

      @table_name
    end

    def table_name
      @table_name ||= store_as name
    end

    def mapping(config=[])
      config.each do |field, doppelganger|
        unless fields.include? field
          fields << CsvRecord::Field.new(field, doppelganger)
        end
      end
    end

    def redefine_database_location
      if const_defined?('DATABASE_LOCATION') || const_defined?('DATABASE_LOCATION_TMP')
        send :remove_const, 'DATABASE_LOCATION'
        send :remove_const, 'DATABASE_LOCATION_TMP'
      end

      const_set 'DATABASE_LOCATION', "db/#{@table_name}.csv"
      const_set 'DATABASE_LOCATION_TMP', "db/#{@table_name}_tmp.csv"
    end

    alias :create :__create__
  end

  module InstanceMethods
    def self.included(receiver)
      receiver.send :attr_accessor, :id
    end

    def __save__(validate=true)
      if (not validate) || valid?
        new_record? ? append_registry : update_registry
      else
        false
      end
    end

    def new_record?
      created_at.nil? || id.nil?
    end

    def __update_attribute__(field, value)
      public_send "#{field}=", value
      save false
    end

    def __update_attributes__(params={validate: true})
      validate = params[:validate]
      params.delete :validate

      params.each do |field, value|
        public_send "#{field}=", value
      end

      yield self if block_given?

      save validate
    end

    def __destroy__
      self.class.parse_database_file do |row|
        new_row = row
        new_row = nil if id.to_i == row.field('id').to_i
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
      write_object
    end

    def update_registry
      self.class.parse_database_file do |row|
        new_row = row
        new_row = values if id.to_i == row.field('id').to_i
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
        public_send "#{field}=", nil
      end
    end

    alias :save :__save__
    alias :write_object :__write_object__
    alias :update_attribute :__update_attribute__
    alias :destroy :__destroy__
    alias :update_attributes :__update_attributes__
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
