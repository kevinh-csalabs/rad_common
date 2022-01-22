require 'rails_helper'

RSpec.describe RadCommon::AppInfo, type: :service do
  let(:service) { described_class.new }

  describe 'application_tables' do
    subject { service.application_tables }

    let(:result) do
      %w[attorneys companies customers divisions duplicates notification_security_roles notification_settings
         notification_types notifications security_roles statuses system_messages user_customers user_security_roles
         user_statuses users]
    end

    it { is_expected.to eq result }
  end

  describe 'application_models' do
    subject { service.application_models }

    let(:result) do
      %w[Attorney Company Customer Division Duplicate Notification NotificationSecurityRole NotificationSetting
         NotificationType SecurityRole Status SystemMessage User UserCustomer UserSecurityRole UserStatus]
    end

    it { is_expected.to eq result }
  end

  describe 'audited_models' do
    subject { service.audited_models }

    let(:result) do
      %w[Attorney Company Customer Division NotificationSecurityRole NotificationSetting SecurityRole Status User
         UserCustomer UserSecurityRole]
    end

    it { is_expected.to eq result }
  end
end
