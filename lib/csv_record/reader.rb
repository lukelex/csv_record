require 'csv_record/query'

module CsvRecord::Reader
  module ClassMethods
    DYNAMIC_FINDER_PATTERN = /^find_by_(.+)$/

    def build(params={})
      inst = new
      params.each do |key, value|
        attribute = fields.find_with_doppelganger(key)
        attr_name = attribute ? attribute.name : key
        inst.public_send "#{attr_name}=", value
      end if params
      yield inst if block_given?
      inst
    end

    def __fields__
      @fields ||= ::CsvRecord::Fields.new
    end

    def __doppelganger_fields__
      self.__fields__.map(&:doppelganger)
    end

    def all
      open_database_file do |csv|
        csv.entries.map { |attributes| self.build attributes }
      end
    end

    def first
      all.first
    end

    def last
      all.last
    end

    def __count__
      open_database_file do |csv|
        csv.entries.size
      end
    end

    def __find__(condition)
      (__where__ id: condition.to_param).first
    end

    def __where__(params)
      ::CsvRecord::Query.new self, params
    end

    def method_missing(meth, *args, &block)
      if meth.to_s =~ DYNAMIC_FINDER_PATTERN
        dynamic_finder $1, *args, &block
      else
        super
      end
    end

    def respond_to?(meth)
      (meth.to_s =~ DYNAMIC_FINDER_PATTERN) || super
    end

    protected

    def dynamic_finder(meth, *args, &block)
      properties = meth.split '_and_'
      conditions = Hash[properties.zip args]
      __where__ conditions
    end

    alias :fields :__fields__
    alias :find :__find__
    alias :count :__count__
    alias :where :__where__
    alias :doppelganger_fields :__doppelganger_fields__
  end

  module InstanceMethods
    def __values__
      self.class.fields.map do |attribute|
        self.public_send attribute.name
      end
    end

    def __attributes__
      Hash[self.class.fields.zip self.values]
    end

    def __to_param__
      self.id.to_s
    end

    def ==(obj)
      self.class == obj.class and self.to_param == obj.to_param
    end

    def !=(obj)
      self.class != obj.class || self.to_param != obj.to_param
    end

    alias :attributes :__attributes__
    alias :values :__values__
    alias :to_param :__to_param__
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
