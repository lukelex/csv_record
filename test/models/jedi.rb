class Jedi
  include CsvRecord::Document

  attr_accessor :name, :age, :midi_chlorians
  attr_reader :custom_validator_checker, :custom_validator_checker_with_block

  belongs_to :jedi_order

  validates_presence_of :name, :age
  validates_uniqueness_of :name

  validate :my_custom_validator_method
  validate do |obj|
    obj.instance_eval do
      @custom_validator_checker_with_block = true
    end
  end

  def initialize(params={})
    params.each do |key, value|
      self.public_send("#{key}=", value)
    end
  end

  private
  def my_custom_validator_method
    @custom_validator_checker = true
  end
end