class JediOrder
  include CsvRecord::Document

  attr_accessor :rank

  has_many :jedis

  def initialize(params={})
    params.each do |key, value|
      self.public_send("#{key}=", value)
    end
  end
end