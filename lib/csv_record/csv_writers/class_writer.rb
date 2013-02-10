module CsvRecord::Writer
  module ClassMethods
    def __create__(attributes={})
      instance = self.build attributes
      yield instance if block_given?
      result = instance.save
      instance
    end

    [:attr_accessor, :attr_writer].each do |custom_accessor|
      define_method custom_accessor do |*args|
        @relevant_instance_variables ||= []
        args.each { |arg| @relevant_instance_variables << arg }
        super *args
      end
    end

    def store_as(name)
      @table_name = name.to_s.underscore.pluralize

      self.const_set 'DATABASE_LOCATION', "db/#{@table_name}.csv"
      self.const_set 'DATABASE_LOCATION_TMP', "db/#{@table_name}_tmp.csv"

      @table_name
    end

    def table_name
      @table_name ||= store_as name
    end

    alias :create :__create__
  end
end