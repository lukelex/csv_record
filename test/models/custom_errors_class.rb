class CustomErrorsClass
  include CsvRecord::Document

  validate :my_custom_validator_method
  validate do
    self.errors.add :custom_error_with_block
  end

  private

  def my_custom_validator_method
    self.errors.add :custom_error
  end
end
