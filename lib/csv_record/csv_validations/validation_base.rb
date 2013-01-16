class CsvRecord::ValidationBase
protected
  def self.uniqueness_block
    Proc.new do
      condition = {}
      condition[attribute] = self.public_send attribute
      records = self.class.__where__ condition
      if records.any? { |record| record != self }
        self.errors.add attribute
      end
    end
  end

  def self.presence_block
    Proc.new do
      if self.public_send(attribute).nil?
        self.errors.add attribute
      end
    end
  end
end
