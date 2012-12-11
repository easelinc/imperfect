require 'pagerduty'

module Imperfect::Alerts
  class Pagerduty
    def initialize(pagerduty_configuration)
      @client = ::Pagerduty.new(pagerduty_configuration[:api_key])
    end
  end
end
