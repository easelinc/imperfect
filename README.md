# Imperfect

Because everyone's software runs in the real world.

It's an unfortunate fact of life that not everything always works
perfectly. However more unfortunately is that all the error reporting
solutions assume that there is a constant threshold above which an error
becomes an alert.

Imperfect takes a different approach. Imperfect measures the ratio of
failures over a given period of time, which is much more useful as you
really care about your success rate rather than an the absolute number
of failures.

## Integrations.

* For storage it uses Amazon Cloudwatch.
* For alerting it uses Pagerduty.

## Setup

1. `gem install imperfect`
1. Configure it.
1. Call it using `Imperfect.success('event')` and `Imperfect.failure('event')`
   to approriately track the event you'd like to watch.

If you'd like to trigger a failure for testing purposes you can call
`Imperfect.trigger_alert!('event')` and it will send an alert using the
current configuration (NOTE: this is to be implemented).

## Configuration

```
Imperfect.configure do |config|
  config.enable_storage :cloudwatch, {
    :access_key_id => "your-aws-id",
    :secret_access_key => "your-aws-secret"
  }
  config.enable_alerts :pagerduty, {
    :api_key => "your-pagerduty-api-key"
  }

  # Minimum time (in seconds) between re-triggering alerts
  config.minimum_alert_update_interval => 60

  # All events that you would alert on must be specified here. Unconfigured
  # events will be silently ignored.
  config.events = {
    'event' => {
      # Alert if the failure rate exceeds this value.
      :acceptable_failure_rate => 0.10,

      # The period of preceding time used to determine the current failure rate,
      # defaults to 300s.
      :lookback_period => 300,

      :alerts => {
        :pagerduty => {
          # The name of the pagerduty service to mark as failed.
          :service_name => 'service-event',
        }
      },

      :storage => {
        :cloudwatch => {
          # The group which this metric should belong to on cloudwatch.
          :namespace => 'Imperfect',
          # The name of the cloudwatch metric to use for success.
          :success_metric_name => 'event-success',
          # The name of the cloudwatch metric to use for failure.
          :failure_metric_name => 'event-failure',
        }
      }
    }
  }
end
```

# Development

1. Checkout the repository
1. Create a feature branch `git checkout -b my-new-feature`
1. `bundle install`
1. Run `guard`
1. Submit a pull request (pulls should be mergable into master, include
   tests for new functionality and be currently passing).

# Future Work

1. Alerting (stub is there but needs implementation)
1. Other data providers (graphite?)
1. Other alert services
