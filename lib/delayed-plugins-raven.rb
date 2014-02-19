require 'raven'
require 'delayed/performable_method'
require 'delayed/plugin'

require 'delayed-plugins-raven/version'

module Delayed::Plugins::Raven
  class Plugin < ::Delayed::Plugin
    module Notify
      def error(job, error)
        begin
          ::Raven.capture_exception(error, {
            configuration: ::Delayed::Plugins::Raven.configuration,
            extra: { delayed_job: get_job_json(job) }
          })
        rescue Exception => e
          Rails.logger.error "Raven logging failed: #{e.class.name}: #{e.message}"
          Rails.logger.flush
        end
        super if defined?(super)
      end

      private

      def get_job_json(job)
        json = job.as_json["job"]
        json["handler"] = trim_lines(json["handler"], ::Delayed::Plugins::Raven.max_handler_lines)
        json["last_error"] = trim_lines(json["last_error"], ::Delayed::Plugins::Raven.max_error_lines)
        json
      end

      def trim_lines(string, limit)
        return string unless limit
        string.lines.to_a.map(&:strip).slice(0, limit).join("\n") if string.present?
      end
    end

    callbacks do |lifecycle|
      lifecycle.before(:invoke_job) do |job|
        payload = job.payload_object
        payload = payload.object if payload.is_a? Delayed::PerformableMethod
        payload.extend Notify
      end
    end
  end

  class << self
    attr_accessor :configuration
    attr_accessor :max_handler_lines, :max_error_lines

    def configure
      @configuration = ::Raven::Configuration.new
      yield(@configuration) if block_given?
      self
    end
  end
end
