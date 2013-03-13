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
    def update(configuration, event_name, status)
      metric_name = configuration[:cloudwatch_metric_name] || event_name
      namespace = configuration[:cloudwatch_namespace] || "Imperfect"

      value = status == :success ? 0 : 1

      @client.put_metric_data(
        :namespace => namespace,
        :metric_data => [{
          :metric_name => metric_name,
          :value => value
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
      total_count = count(configuration, event_name, :total, period)
      failure_count = count(configuration, event_name, :failure, period)

      failure_count/total_count.to_f
    end

  protected
    # Protected: Returns the number of instances of the event in the
    # given period of time.
    #
    # configuration - The Hash of configuration for this storage
    #                 method.
    # event_name    - The name of the event to be stored
    # type          - Either :total or :failure
    # period        - The number of seconds to look back.
    #
    # Returns the number of occurences of the specified event.
    def count(configuration, event_name, type, period)
      metric_name = configuration[:cloudwatch_metric_name] || event_name
      namespace = configuration[:cloudwatch_namespace] || "Imperfect"
      start_time = Time.now - period
      end_time = start_time + period

      metric = ::AWS::CloudWatch::Metric.new(namespace, metric_name, :config => @client.config)
      statistic = type == :total ? 'Count' : 'Sum'
      statistics = metric.statistics(
        :start_time => start_time,
        :end_time => end_time,
        :statistics => [statistic],
        :period => period
      )

      if statistics.first
        statistics.first[statistic.downcase.to_sym]
      else
        0
      end
    end
  end
end
