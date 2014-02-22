module Delayed::Plugins::Raven
  class Configuration

    # Exclude certain attributes from being serialized into Raven's `extra` field
    attr_accessor :excluded_attributes

    # Trim specificed attributes to a certain number of lines. Values <= 0 means unlimited.
    attr_accessor :trimmed_attributes

    def initialize
      self.excluded_attributes = ["last_error"]
      self.trimmed_attributes = { "handler" => -1, "last_error" => 10 }
    end

  end
end
