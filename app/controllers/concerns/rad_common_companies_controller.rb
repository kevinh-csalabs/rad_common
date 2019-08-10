module RadCommonCompaniesController
  extend ActiveSupport::Concern

  def global_validity_check
    unless Rails.application.config.global_validity_enable_interactive
      raise 'interactive global validity check not enabled'
    end

    authorize_action_for @company

    GlobalValidityJob.perform_later(current_user)

    flash[:success] = "We're checking the validity of all of your company's data. You will get an email with "\
                      'the results. This may take a while.'

    redirect_to company_path(@company)
  end
end
