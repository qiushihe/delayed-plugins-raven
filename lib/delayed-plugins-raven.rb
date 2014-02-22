require 'raven'
require 'delayed/performable_method'
require 'delayed/plugin'

require 'delayed-plugins-raven/version'
require 'delayed-plugins-raven/configuration'

module Delayed::Plugins::Raven
  class Plugin < ::Delayed::Plugin
    module Notify
      def error(job, error)
        begin
          ::Raven.capture_exception(error, {
            configuration: ::Delayed::Plugins::Raven.raven_configuration,
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

        if (excluded_attributes = plugin_config.excluded_attributes).present?
          excluded_attributes.each { |attribute| json.delete(attribute) }
        end

        if (limits = plugin_config.trimmed_attributes).present?
          limits.each do |attribute, limit|
            json[attribute] = trim_lines(json[attribute], limit) if limit > 0
          end
        end

        json
      end

      def trim_lines(string, limit)
        return string unless limit
        string.lines.to_a.map(&:strip).slice(0, limit).join("\n") if string.present?
      end

      def plugin_config
        ::Delayed::Plugins::Raven.plugin_configuration ||= ::Delayed::Plugins::Raven::Configuration.new
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
    attr_accessor :raven_configuration
    attr_accessor :plugin_configuration

    # Note: Deprecated; Use Delayed::Plugins::Raven.configure_raven instead.
    def configure(&block)
      configure_raven(&block)
    end

    def configure_raven(&block)
      @raven_configuration = ::Raven::Configuration.new
      block.call(@raven_configuration) if block
      self
    end

    def configure_plugin(&block)
      @plugin_configuration = Delayed::Plugins::Raven::Configuration.new
      block.call(@plugin_configuration) if block
      self
    end
  end
end
