require 'spec_helper'

describe Citygram::Services::Notifications::Email do
  include Mail::Matchers

  subject { Citygram::Services::Notifications::Email }

  let(:subscription) { create(:subscription, channel: 'email', contact: to_email_address) }
  let(:event) { create(:event) }

  let(:to_email_address) { Faker::Internet.email }
  let(:from_email_address) { ENV.fetch('SMTP_FROM_ADDRESS') }

  around do |example|
    original = Pony.options.dup
    Pony.options = Pony.options.merge(via: :test)
    example.run
    Pony.options = original
  end

  context 'success' do
    before do
      subject.call(subscription, event)
    end

    it { is_expected.to have_sent_email.from(from_email_address) }
    it { is_expected.to have_sent_email.to(to_email_address) }
    it { is_expected.to have_sent_email.with_subject(event.title) }
  end

  context 'failure' do
    # TODO
  end
end