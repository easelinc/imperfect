require 'imperfect/version'

class Imperfect
  # Public: Allows the configuration of Imperfect using the given block.
  #
  # Example:
  #
  #  Imperfect.configure do |config|
  #    config.aws_access_key_id = "your-aws-id"
  #    config.aws_secret_access_key = "your-aws-secret"
  #    config.pagerduty_api_key = "your-pagerduty-api-key"

  #    # Minimum time (in seconds) between re-trigger alert (this prevents
  #    # overloading your alert provider if every event results in a failure)
  #    config.minimum_alert_update_interval => 60

  #    # All events that you would alert on must be specified here. Unconfigured
  #    # events will be silently ignored.
  #    config.events = {
  #      'event' => {
  #        # Alert if the failure rate exceeds this value.
  #        :acceptable_failure_rate => 0.10,

  #        # The period of preceding time used to determine the current failure rate,
  #        # defaults to 300s.
  #        :lookback_time_period => 300,

  #        # The name of the pagerduty service to mark as failed.
  #        :pagerduty_service_name => 'service-event',
  #      }
  #    }
  #  end
  #
  # Returns nothing.
  def self.configure
    yield self
  end

  # Public: Track a successful completion of the given event.
  #
  # event - The name of the successful event.
  #
  # Returns nothing.
  def self.success(event)
  end

  # Public: Track a unsuccessful completion of the given event.
  #
  # event - The name of the successful event.
  #
  # Returns nothing.
  def self.failure(event)
  end

  # Test-only: This function is used to test whether an alerting
  # configuration works as expected.
  #
  # Returns nothing.
  def self.trigger_alert!(event)
  end
end
