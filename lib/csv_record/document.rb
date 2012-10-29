require 'csv_record/connector'
require 'csv_record/writer'
require 'csv_record/reader'
require 'csv_record/timestamps'
require 'csv_record/callbacks'
require 'csv_record/helpers'

module CsvRecord

  # This is the base module for all domain objects that need to be persisted to
  # the database.
  module Document
    def self.included(receiver)
      self.const_set('DATABASE_LOCATION',"db/#{parse_caller(caller[1]).downcase}.csv")
      self.const_set('DATABASE_LOCATION_TMP',"db/#{parse_caller(caller[1]).downcase}_tmp.csv")

      receiver.extend         CsvRecord::Connector
      receiver.extend         CsvRecord::Writer::ClassMethods
      receiver.extend         CsvRecord::Reader::ClassMethods
      receiver.send :include, CsvRecord::Writer::InstanceMethods
      receiver.send :include, CsvRecord::Reader::InstanceMethods
      receiver.send :include, CsvRecord::Timestamps
      receiver.send :include, CsvRecord::Callbacks
    end

    def self.parse_caller(at)
      /(?:(\<class\:)(\w+))/ =~ at
      $2
    end
  end
end