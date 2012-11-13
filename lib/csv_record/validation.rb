module CsvRecord
  module Validation
    def validates_presence_of(*attr_names)

    end
    private
    def stringify(term)
      term.to_s
    end
  end
end