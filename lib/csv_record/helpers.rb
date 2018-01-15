# frozen_string_literal: true

class Object
  def integer?
    /(?<number>^\d+$)/ =~ to_s
    not number.nil?
  end

  def float?
    /(?<number>^\d+\.\d+)$/ =~ to_s
    not number.nil?
  end

  def to_param
    self
  end

  def underscored_class_name
    self.class.name.underscore
  end
end

class String
  def constantize
    split('_').map { |w| w.capitalize }.join
  end

  def to_class
    Object.const_get constantize.singularize
  end

  def underscore
    gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end
