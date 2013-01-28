require 'csv_record/csv_readers/class_reader'
require 'csv_record/csv_readers/instance_reader'

module CsvRecord::Reader
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end