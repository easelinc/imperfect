require 'spec_helper'

describe 'Imperfect::Storage::Cloudwatch' do
  subject do
    Imperfect::Storage::Cloudwatch.new(:secret_access_key => 'secret', :access_key_id => 'id')
  end

  describe '#update' do
    context 'with a success' do
      it 'submits the data to cloudwatch' do
        stub = stub_request(:post, 'https://monitoring.us-east-1.amazonaws.com/').
          with(:body => hash_including(
            'Namespace' => 'namespace',
            'MetricData.member.1.MetricName' => 'event',
            'MetricData.member.1.Value' => '0.0'
            )
          )

        subject.update({ :cloudwatch_namespace => 'namespace' }, 'event', :success)
        stub.should have_been_requested
      end
    end

    context 'with a failure' do
      it 'submits the data to cloudwatch' do
        stub = stub_request(:post, 'https://monitoring.us-east-1.amazonaws.com/').
          with(:body => hash_including(
            'Namespace' => 'namespace',
            'MetricData.member.1.MetricName' => 'event',
            'MetricData.member.1.Value' => '1.0'
            )
          )

        subject.update({ :cloudwatch_namespace => 'namespace' }, 'event', :failure)
        stub.should have_been_requested
      end
    end
  end

  describe 'error_rate' do
    it 'submits the data to cloudwatch' do
      success = """
      <GetMetricStatisticsResponse xmlns=\"http://monitoring.amazonaws.com/doc/2010-08-01/\">\n
        \ <GetMetricStatisticsResult>\n    <Datapoints>\n      <member>\n        <Timestamp>2012-12-11T19:00:00Z</Timestamp>\n
        \       <Unit>Count</Unit>\n        <Count>100.0</Count>\n      </member>\n    </Datapoints>\n
        \   <Label>event</Label>\n  </GetMetricStatisticsResult>\n
        \ <ResponseMetadata>\n    <RequestId>b94b3c91-43c5-11e2-be9b-799373c9f0f2</RequestId>\n
        \ </ResponseMetadata>\n</GetMetricStatisticsResponse>\n
      """
      failure = """
      <GetMetricStatisticsResponse xmlns=\"http://monitoring.amazonaws.com/doc/2010-08-01/\">\n
        \ <GetMetricStatisticsResult>\n    <Datapoints>\n      <member>\n        <Timestamp>2012-12-11T19:00:00Z</Timestamp>\n
        \       <Unit>Count</Unit>\n        <Sum>5.0</Sum>\n      </member>\n    </Datapoints>\n
        \   <Label>event</Label>\n  </GetMetricStatisticsResult>\n
        \ <ResponseMetadata>\n    <RequestId>b94b3c91-43c5-11e2-be9b-799373c9f0f2</RequestId>\n
        \ </ResponseMetadata>\n</GetMetricStatisticsResponse>\n
      """
      stub = stub_request(:post, 'https://monitoring.us-east-1.amazonaws.com/').to_return(:body => success).then.to_return(:body => failure)

      subject.error_rate({}, 'event', 300).should eq(0.05)
      stub.should have_been_requested.twice
    end
  end
end
