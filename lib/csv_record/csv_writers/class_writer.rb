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

    alias :create :__create__
  end
end