require 'active_support/core_ext/string/inflections.rb'

require 'csv_record/connector'
require 'csv_record/csv_writers/writer'
require 'csv_record/csv_readers/reader'
require 'csv_record/timestamps'
require 'csv_record/callbacks'
require 'csv_record/helpers'
require 'csv_record/associations'
require 'csv_record/csv_validations/validations'

# This is the base module for all domain objects that need to be persisted to
# the database.
module CsvRecord::Document
  def self.included(receiver)
    table_name = receiver.name.underscore.pluralize

    receiver.const_set 'DATABASE_LOCATION',"db/#{table_name}.csv"
    receiver.const_set 'DATABASE_LOCATION_TMP',"db/#{table_name}_tmp.csv"

    receiver.extend         CsvRecord::Connector
    receiver.extend         CsvRecord::Associations
    receiver.extend         CsvRecord::Validations::ClassMethods
    receiver.send :include, CsvRecord::Writer
    receiver.send :include, CsvRecord::Reader
    receiver.send :include, CsvRecord::Validations::InstanceMethods
    receiver.send :include, CsvRecord::Callbacks
    receiver.send :include, CsvRecord::Timestamps
  end
end