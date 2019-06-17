# frozen_string_literal: true

RSpec.describe HelpScout::API::AccessToken do
  let(:access_token_params) { JSON.parse(access_token_json, symbolize_names: true) }
  let(:access_token) { described_class.new(access_token_params) }

  describe '.new' do
    context 'when an expires_at param is passed' do
      let(:access_token_params) { super().merge(expires_at: Time.now.utc.to_s) }

      it 'sets expires_in to nil' do
        expect(access_token.expires_in).to be_nil
      end
    end
  end

  describe '.create' do
    subject { described_class.create }

    it { is_expected.to be_a described_class }
  end

  describe '.refresh!' do
    subject { described_class.refresh! }

    context 'when the token is valid' do
      before { HelpScout.api.access_token = access_token }

      it 'does not call create' do
        expect(described_class).not_to receive(:create)

        subject
      end

      it 'returns the token' do
        expect(subject).to eq(access_token)
      end
    end

    context 'when the token is stale' do
      let(:initial_token) do
        described_class.new(
          token_type: 'bearer',
          access_token: 'initial42token',
          expires_in: 7200
        )
      end

      before do
        allow(initial_token).to receive(:stale?).and_return(true)
        HelpScout.api.access_token = initial_token
      end

      it 'calls create' do
        expect(described_class).to receive(:create)

        subject
      end

      it 'returns the newly created token' do
        new_token = subject

        expect(new_token).to be_a(described_class)
        expect(new_token.value).not_to eq(initial_token.value)
        expect(new_token.value).to eq(access_token_params[:access_token])
      end
    end

    context 'when the token is nil' do
      before { HelpScout.api.access_token = nil }

      it 'calls create' do
        expect(described_class).to receive(:create)

        subject
      end

      it 'returns the newly created token' do
        new_token = subject

        expect(new_token).to be_a(described_class)
        expect(new_token.value).to eq(access_token_params[:access_token])
      end
    end
  end

  describe '#as_json' do
    subject { access_token.as_json }

    it 'includes the value and expires_at attributes' do
      expect(subject).to eq(
        access_token: access_token.value,
        expires_at: access_token.expires_at
      )
    end
  end

  describe '#expires_in' do
    subject { access_token.expires_in }

    it { is_expected.to eq(access_token_params[:expires_in]) }
  end

  describe '#expired?' do
    subject { access_token.expired? }

    context 'when the token is likely to be expired' do
      let(:access_token_params) { super().merge(expires_in: -100) }

      it { is_expected.to eq true }
    end

    context 'when the token is not likely to be expired' do
      it { is_expected.to eq false }
    end

    context 'when the token has no expired_at time set' do
      let(:access_token_params) { super().merge(expires_in: nil, expires_at: nil) }

      it { is_expected.to eq false }
    end
  end

  describe '#invalidate!' do
    subject { access_token.invalidate! }

    context 'when no cache is configured' do
      around { |example| with_config(token_cache: nil) { example.run } }

      it 'marks the access token as invalid' do
        expect { subject }.to change { access_token.invalid? }.from(false).to(true)
      end

      it 'does not attempt to clear the cache' do
        expect_any_instance_of(HelpScout::API::AccessToken::Cache).not_to receive(:delete)

        subject
      end
    end

    context 'when a cache is configured' do
      let(:token_cache) { double('cache') }

      around { |example| with_config(token_cache: token_cache) { example.run } }

      before { allow(token_cache).to receive(:delete) }

      it 'marks the access token as invalid' do
        expect { subject }.to change { access_token.invalid? }.from(false).to(true)
      end

      it 'attempts to clear the cache' do
        expect(token_cache).to receive(:delete)

        subject
      end
    end
  end

  describe '#value' do
    subject { access_token.value }

    it { is_expected.to eq(access_token_params[:access_token]) }
  end
end
