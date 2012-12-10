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
1. Add imperfect to your gemfile.
1. Configure it.
1. Call it using `Imperfect.success('event')` and `Imperfect.failure('event')`
   to approriately track the event you'd like to watch.

If you'd like to trigger a failure for testing purposes you can call
`Imperfect.trigger_alert!('event')` and it will send an alert using the
current configuration.

## Configuration

```
Imperfect.configure do |config|
  config.aws_access_key_id = "your-aws-id"
  config.aws_secret_access_key = "your-aws-secret"
  config.pagerduty_api_key = "your-pagerduty-api-key"

  # Minimum time (in seconds) between re-trigger alert (this prevents
  # overloading your alert provider if every event results in a failure)
  config.minimum_alert_update_interval => 60

  # All events that you would alert on must be specified here. Unconfigured
  # events will be silently ignored.
  config.events = {
    'event' => {
      # Alert if the failure rate exceeds this value.
      :acceptable_failure_rate => 0.10,

      # The period of preceding time used to determine the current failure rate,
      # defaults to 300s.
      :lookback_time_period => 300,

      # The name of the pagerduty service to mark as failed.
      :pagerduty_service_name => 'service-event',
    }
  }
end
```

# Testing

1. Run `rake test`

# Future Work

1. Other data providers (graphite?)
1. Other alert services
