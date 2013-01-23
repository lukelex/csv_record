# This module handles the behaviour for setting up document created at
# timestamp.
module CsvRecord::Timestamps
  def self.included(receiver)
    receiver.send :attr_accessor, :created_at
    receiver.send :attr_accessor, :updated_at
  end

private

  # Update the created_at field on the Document to the current time. This is
  # only called on create.
  #
  # @example Set the created at time.
  #   person.set_created_at
  def __set_created_at__
    if !created_at
      time = Time.now.utc
      @created_at = time
      @updated_at = time
    end
  end

  # Update the created_at field on the Document to the current time. This is
  # called on each save.
  #
  # @example Set the updated at time.
  #   person.set_updated_at
  def __set_updated_at__
    @updated_at = Time.now.utc
  end

  alias :set_created_at :__set_created_at__
  alias :set_updated_at :__set_updated_at__
end