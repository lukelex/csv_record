module CsvRecord::Associations
  def belongs_to(klass)
    klass_name = klass.to_s

    self.class_eval do
      self.send :attr_writer, "#{klass}_id"

      define_method klass do
        klass_name.to_class.find self.id
      end
      define_method "#{klass}=" do |value|
        self.send "#{klass}_id=", value.to_param
      end
      define_method "#{klass}_id" do
        eval("@#{klass}_id").to_i
      end
    end
  end

  def has_many(klass)
    self.class_eval do
      define_method klass do
        klass.to_s.to_class.where :"#{self.underscored_class_name}_id" => self.id
      end
    end
  end

  def has_one(klass)
    self.class_eval do
      define_method "#{klass}=" do |obj|
        obj.send "#{self.underscored_class_name}_id=", self.id
        obj.save
      end
      define_method klass do
        klass.to_s.to_class.where("#{self.underscored_class_name}_id" => self.id).first
      end
    end
  end
end