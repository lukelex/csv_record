class CsvRecord::Fields
  include Enumerable

  def fields
    @fields ||= []
  end

  def <<(field)
    fields << field
  end

  def include?(field)
    has_doppelganger? field
  end

  [:name, :doppelganger].each do |attribute|
    define_method "has_#{attribute}?" do |field|
      fields.any? do |field_model|
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
    fields.each(&block)
  end

  def method_missing(meth, *args, &block)
    if to_a.respond_to?(meth)
      to_a.public_send(meth, *args, &block)
    else
      super
    end
  end

  alias :add :<<
end
