module CsvRecord
  module Timestamps
    attr_reader :created_at

    def set_creation_time
      occurrence = Time.new
      @created_at = occurrence
    end
  end
end