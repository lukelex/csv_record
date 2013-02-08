module CsvRecord::Reader
  module InstanceMethods
    def __values__
      self.class.fields.map { |attribute| self.public_send attribute }
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
end