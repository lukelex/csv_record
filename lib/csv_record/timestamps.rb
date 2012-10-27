module CsvRecord
  # This module handles the behaviour for setting up document created at
  # timestamp.
  module Timestamps
    def self.included(receiver)
      receiver.send :attr_accessor, :created_at
    end

    # Update the created_at field on the Document to the current time. This is
    # only called on create.
    #
    # @example Set the created at time.
    #   person.set_created_at
    def __set_created_at__
      if !created_at
        time = Time.now.utc
        # self.updated_at = time if is_a?(Updated) && !updated_at_changed?
        @created_at = time
      end
    end

    alias :set_created_at :__set_created_at__
  end
end