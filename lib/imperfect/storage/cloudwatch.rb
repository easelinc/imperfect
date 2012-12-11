require 'aws-sdk'

module Imperfect::Storage
  class Cloudwatch
    def initialize(cloudwatch_configuration)
      @client = ::AWS::CloudWatch.new(cloudwatch_configuration)
    end

    # Public: Records the status of the given event.
    #
    # configuration - The Hash of configuration for this storage
    #                 method.
    # event_name    - The name of the event to be stored
    # status        - Either :success or :failure]
    #
    # Returns nothing.
    def increment(configuration, event_name, status)
      config_key = "#{status}_metric_name".to_sym
      metric_name = configuration[config_key] || "#{event_name}-#{status}"
      namespace = configuration[:namespace] || "Imperfect"

      @client.put_metric_data(
        :namespace => namespace,
        :metric_data => [{
          :metric_name => metric_name,
          :value => 1
        }]
      )
    end

    # Protected: Returns the current error rate.
    #
    # configuration - The Hash of configuration for this storage
    #                 method.
    # event_name    - The name of the event to be stored
    # status        - Either :success or :failure
    # period        - The number of seconds to look back.
    def error_rate(configuration, event_name, period)
      success_count = count(configuration, event_name, :success, period)
      failure_count = count(configuration, event_name, :failure, period)

      failure_count/(failure_count + success_count).to_f
    end

  protected
    # Protected: Returns the number of instances of the event in the
    # given period of time.
    #
    # configuration - The Hash of configuration for this storage
    #                 method.
    # event_name    - The name of the event to be stored
    # status        - Either :success or :failure
    # period        - The number of seconds to look back.
    def count(configuration, event_name, status, period)
      config_key = "#{status}_metric_name".to_sym
      metric_name = configuration[config_key] || "#{event_name}-#{status}"
      namespace = configuration[:namespace] || "Imperfect"
      start_time = Time.now - period
      end_time = start_time + period

      metric = ::AWS::CloudWatch::Metric.new(namespace, metric_name, :config => @client.config)
      statistics = metric.statistics(
        :start_time => start_time,
        :end_time => end_time,
        :statistics => ['Sum'],
        :period => period
      )

      if statistics.first
        statistics.first[:sum]
      else
        0
      end
    end
  end
end
