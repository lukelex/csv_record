class CsvRecord::CustomValidation
  attr_accessor :message

  def initialize(message)
    self.message = message
  end

  def run_on(obj)
    if self.message.is_a? Proc
      obj.instance_eval &self.message
    else
      obj.send self.message
    end
  end

private
  def get_correct_block_type
    self.class.send "#{self.type}_block"
  end
end
