require 'spec_helper'

describe 'Imperfect' do
  subject do
    Imperfect
  end

  it 'should have a version' do
    Imperfect::VERSION.should_not be_nil
  end

  describe 'configuring' do
    context 'global enabled' do
      before do
        subject.configure do |config|
          config.enabled = true
        end
      end
      it 'exists' do
        subject.configuration.enabled.should be_true
      end
    end

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

  context 'with storage' do
    let(:event_configuration) {
      {
        :storage => {
          :cloudwatch => {
            :namespace => 'Imperfect',
            :success_metric_name => 'event-success',
            :failure_metric_name => 'event-failure'
          }
        }
      }
    }

    before do
      subject.configure do |config|
        config.enable_storage(:cloudwatch, :access_key_id => 'id', :secret_key => 'secret')
        config.events = { 'event' => event_configuration }
      end
    end

    context 'when enabled' do
      describe 'success' do
        it 'stores a datapoint' do
          subject.configuration.storage.should_receive(:increment).with(event_configuration[:storage], 'event', :success)
          subject.success('event')
        end
      end

      describe 'failure' do
        it 'stores a datapoint' do
          subject.configuration.storage.should_receive(:increment).with(event_configuration[:storage], 'event', :failure)
          subject.failure('event')
        end
      end
    end

    context 'when disabled' do
      before do
        subject.configuration.enabled = false
      end

      describe 'success' do
        it 'does nothing' do
          subject.configuration.storage.should_not_receive(:increment)
          subject.success('event')
        end
      end

      describe 'failure' do
        it 'does nothing' do
          subject.configuration.storage.should_not_receive(:increment)
          subject.failure('event')
        end
      end
    end
  end
end
