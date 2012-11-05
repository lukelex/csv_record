class Object
  def integer?
    self.to_s =~ /^\d+$/
    !$0.empty?
  end

  def float?
    self.to_s =~ /^\d+\.\d+$/
    !$0.empty?
  end

  def to_param
    self
  end
end