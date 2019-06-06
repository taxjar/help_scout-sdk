# frozen_string_literal: true

RSpec.describe HelpScout::API do
  subject { described_class.new }

  describe 'access token' do
    let(:connection) { double('HelpScout::API::Client#authorized_connection') }

    before do
      expect(subject).to receive(:new_connection).and_return(connection)
    end

    describe 'when the token is valid' do
      let(:response_1) { OpenStruct.new(status: 200, success?: true) }

      before do
        expect(connection).to receive(:send).once.and_return(response_1)
        expect(HelpScout::API::AccessToken).to receive(:refresh!).never
      end

      it "doesn't refresh the token and makes a single request" do
        subject.get('foo')
      end
    end

    describe 'when the token is invalid' do
      let(:response_1) { OpenStruct.new(status: 401) }
      let(:response_2) { response_1 }

      before do
        expect(connection).to receive(:send).twice.and_return(response_1, response_2)
        expect(HelpScout::API::AccessToken).to receive(:refresh!).once
      end

      context 'and second request is successful' do
        let(:response_2) { OpenStruct.new(status: 200, body: '', success?: true) }

        it 'refreshes the token and makes the request again' do
          subject.get('foo')
        end
      end

      context 'and refresh in unsuccessful' do
        it 'raises an exception' do
          expect { subject.get('foo') }.to raise_error(HelpScout::API::NotAuthorized)
        end
      end
    end
  end
end
