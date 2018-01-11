# frozen_string_literal: true

class CsvRecord::Callback
  attr_accessor :kind, :code

  def initialize(kind, code)
    self.kind = kind
    self.code = code
  end

  def run_on(obj)
    obj.instance_eval(&self.code)
  end
end
