require 'imperfect/version'
require 'imperfect/storage'
require 'imperfect/alerts'

class Imperfect
  class << self
    attr_accessor :configuration
  end

  # Public: Allows the configuration of Imperfect using the given block.
  #
  # Example:
  #
  #  Imperfect.configure do |config|
  #    config.enabled = Rails.env.production?
  #
  #    config.enable_storage :cloudwatch, {
  #      :access_key_id => "your-aws-id",
  #      :secret_access_key => "your-aws-secret"
  #    }
  #    config.enable_alerts :pagerduty, {
  #      :api_key => "your-pagerduty-api-key"
  #    }
  #
  #    # Minimum time (in seconds) between re-triggering alerts
  #    config.minimum_alert_update_interval => 60
  #
  #    # All events that you would alert on must be specified here. Unconfigured
  #    # events will be silently ignored.
  #    config.events = {
  #      'event' => {
  #        # Alert if the failure rate exceeds this value.
  #        :acceptable_failure_rate => 0.10,
  #
  #        # The period of preceding time used to determine the current failure rate,
  #        # defaults to 300s.
  #        :lookback_period => 300,
  #
  #        :alerts => {
  #          :pagerduty => {
  #            # The name of the pagerduty service to mark as failed.
  #            :service_name => 'service-event',
  #          }
  #        },
  #
  #        :storage => {
  #          :cloudwatch => {
  #            # The group which this metric should belong to on cloudwatch.
  #            :namespace => 'Imperfect',
  #            # The name of the cloudwatch metric to use for success.
  #            :success_metric_name => 'event-success',
  #            # The name of the cloudwatch metric to use for failure.
  #            :failure_metric_name => 'event-failure',
  #          }
  #        }
  #      }
  #    }
  #  end
  #
  # Returns nothing.
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  # Public: Track a successful completion of the given event.
  #
  # event - The name of the successful event.
  #
  # Returns nothing.
  def self.success(event)
    return unless configuration.enabled

    event_configuration = configuration.events[event]
    return unless event_configuration

    configuration.storage.increment(event_configuration[:storage], event, :success)
  end

  # Public: Track a unsuccessful completion of the given event.
  #
  # event - The name of the successful event.
  #
  # Returns nothing.
  def self.failure(event)
    return unless configuration.enabled

    event_configuration = configuration.events[event]
    return unless event_configuration

    configuration.storage.increment(event_configuration[:storage], event, :failure)
  end

  # Test-only: This function is used to test whether an alerting
  # configuration works as expected.
  #
  # Returns nothing.
  def self.trigger_alert!(event)
    return unless configuration.enabled
  end

  class Configuration
    attr_accessor :minimum_alert_update_interval, :events, :enabled
    attr_reader :storage, :alerts

    def initialize
      @minimum_alert_update_interval = 60
      @enabled = true
      @events = {}
    end

    def enable_storage(type, configuration)
      @storage = case type
      when :cloudwatch
        Imperfect::Storage::Cloudwatch.new(configuration)
      else
        raise "Invalid storage type: #{type}"
      end
    end

    def enable_alerts(type, configuration)
      @alerts = case type
      when :pagerduty
        Imperfect::Alerts::Pagerduty.new(configuration)
      else
        raise "Invalid alert type: #{type}"
      end
    end
  end
end
