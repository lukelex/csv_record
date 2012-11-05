require 'linguistics'
Linguistics.use :en

require 'csv_record/connector'
require 'csv_record/writer'
require 'csv_record/reader'
require 'csv_record/timestamps'
require 'csv_record/callbacks'
require 'csv_record/helpers'
require 'csv_record/associations'

module CsvRecord

  # This is the base module for all domain objects that need to be persisted to
  # the database.
  module Document
    def self.included(receiver)
      klass = receiver.name

      def klass.underscore
        self.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
      end

      receiver.const_set 'DATABASE_LOCATION',"db/#{klass.underscore.en.plural}.csv"
      receiver.const_set 'DATABASE_LOCATION_TMP',"db/#{klass.underscore.en.plural}_tmp.csv"

      receiver.extend         CsvRecord::Connector
      receiver.extend         CsvRecord::Writer::ClassMethods
      receiver.extend         CsvRecord::Reader::ClassMethods
      receiver.extend         CsvRecord::Associations
      receiver.send :include, CsvRecord::Writer::InstanceMethods
      receiver.send :include, CsvRecord::Reader::InstanceMethods
      receiver.send :include, CsvRecord::Timestamps
      receiver.send :include, CsvRecord::Callbacks
    end
  end
end