require 'spec_helper'

describe 'Imperfect' do
  subject do
    Imperfect
  end

  it 'should have a version' do
    Imperfect::VERSION.should_not be_nil
  end

  describe 'configuring' do
    context 'storage with cloudwatch' do
      before do
        subject.configure do |config|
          config.enable_storage(:cloudwatch, :access_key_id => 'id', :secret_key => 'secret')
        end
      end
      it 'exists' do
        subject.configuration.storage.should_not be_nil
      end
    end

    context 'alerting with pagerduty' do
      before do
        subject.configure do |config|
          config.enable_alerts(:pagerduty, :api_key => 'secret')
        end
      end
      it 'exists' do
        subject.configuration.alerts.should_not be_nil
      end
    end

    context 'configuring an event' do
      before do
        subject.configure do |config|
          config.events = {
            'event' => {
              :acceptable_failure_rate => 0.10,
              :lookback_period => 300,
              :alerts => {
                :pagerduty => {
                  :service_name => 'service-event',
                }
              },
              :storage => {
                :cloudwatch => {
                  :namespace => 'Imperfect',
                  :success_metric_name => 'event-success',
                  :failure_metric_name => 'event-failure',
                }
              }
            }
          }
        end
      end

      it 'has an event' do
        subject.configuration.events['event'].should_not be_nil
      end
    end
  end
end
