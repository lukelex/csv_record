require 'csv'

require 'csv_record/version'

require 'csv_record/document'

module CsvRecord
  # Sets the CsvRecord configuration options. Best used by passing a block.
  #
  # @example Set up configuration options.
  #   CsvRecord.configure do |config|
  #   end
  #
  # @return [ self ] The CsvRecord object.
  def configure
    block_given? ? yield(self) : self
  end
end
