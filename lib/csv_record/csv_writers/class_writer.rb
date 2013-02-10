module CsvRecord::Writer
  module ClassMethods
    def __create__(attributes={})
      instance = self.build attributes
      yield instance if block_given?
      result = instance.save
      instance
    end

    [:attr_accessor, :attr_writer].each do |custom_accessor|
      define_method custom_accessor do |*attributes|
        attributes.each do |attribute|
          unless self.fields.has_field? attribute
            self.fields << CsvRecord::Field.new(attribute)
          end
        end
        super *attributes
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
        unless self.fields.include? field
          self.fields << (CsvRecord::Field.new field, doppelganger)
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
end