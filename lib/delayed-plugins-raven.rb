require 'raven'
require 'delayed/performable_method'
require 'delayed/plugin'

require 'delayed-plugins-raven/version'

module Delayed::Plugins::Raven
  class Plugin < ::Delayed::Plugin
    module Notify
      def error(job, error)
        begin
          ::Raven.capture_exception(error, { extra: {
            delayed_job: job.as_json
          } })
        rescue Exception => e
          Rails.logger.error "Raven logging failed: #{e.class.name}: #{e.message}"
          Rails.logger.flush
        end
        super if defined?(super)
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
end
