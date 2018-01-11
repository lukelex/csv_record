class Jedi
  include CsvRecord::Document

  attr_accessor :name, :age, :midi_chlorians
  attr_reader :custom_validator_checker, :custom_validator_checker_with_block, :after_destroy_value, :after_save_value

  after_destroy :my_after_destroy_method
  after_save :my_after_save_method
  belongs_to :jedi_order
  has_one :padawan

  validates_presence_of :name, :age
  validates_uniqueness_of :name

  def initialize(params={})
    params.each do |key, value|
      public_send "#{key}=", value
    end
  end

  private

  def my_custom_validator_method
    @custom_validator_checker = true
  end
  def my_after_destroy_method
    @after_destroy_value = true
  end
  def my_after_save_method
    @after_save_value = true
  end
end
