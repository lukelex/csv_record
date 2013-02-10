class CustomizedClass
  include CsvRecord::Document

  store_as :modification

  attr_accessor :name

  def initialize(params={})
    params.each do |key, value|
      self.public_send("#{key}=", value)
    end
  end


end