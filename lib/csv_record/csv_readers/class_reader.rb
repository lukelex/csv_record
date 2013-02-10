require 'csv_record/csv_queries/query'

module CsvRecord::Reader
  module ClassMethods
    DYNAMIC_FINDER_PATTERN = /^find_by_(.+)$/

    def build(params={})
      inst = new
      params.each do |key, value|
        inst.public_send "#{key}=", value
      end if params
      yield inst if block_given?
      inst
    end

    def __fields__
      @fields ||= CsvRecord::CsvFields.new
    end

    def doppelganger_fields
      self.__fields__.map &:doppelganger
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
      CsvRecord::Query.new self, params
    end

    def method_missing(meth, *args, &block)
      if meth.to_s =~ DYNAMIC_FINDER_PATTERN
        dynamic_finder $1, *args, &block
      else
        super # You *must* call super if you don't handle the
              # method, otherwise you'll mess up Ruby's method
              # lookup.
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
  end
end