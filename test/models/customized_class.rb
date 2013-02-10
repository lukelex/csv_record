class CustomizedClass
  include CsvRecord::Document

  store_as :wierd_name

  mapping :name => :wierd_field

  attr_accessor :name
end

# raise UndefienedCsvField unless self.fields.include? key