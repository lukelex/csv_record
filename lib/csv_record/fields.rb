class CsvRecord::Fields
  include Enumerable

  def fields
    @fields ||= []
  end

  def <<(field)
    self.fields << field
  end

  def include?(field)
    self.has_doppelganger? field
  end

  [:name, :doppelganger].each do |attribute|
    define_method "has_#{attribute}?" do |field|
      self.fields.any? do |field_model|
        field_model.public_send(attribute) == field
      end
    end
  end

  def find_with_doppelganger(doppelganger)
    self.fields.select do |field|
      field.is? doppelganger
    end.first
  end

  def each(&block)
    self.fields.each(&block)
  end

  def method_missing(meth, *args, &block)
    if self.to_a.respond_to?(meth)
      self.to_a.public_send(meth, *args, &block)
    else
      super
    end
  end

  alias :add :<<
end
