require 'csv_record/csv_writers/instance_writer'
require 'csv_record/csv_writers/class_writer'

module CsvRecord::Writer
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end