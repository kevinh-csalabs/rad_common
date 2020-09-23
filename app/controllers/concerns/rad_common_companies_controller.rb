module RadCommonCompaniesController
  extend ActiveSupport::Concern

  def global_validity_check
    authorize @company

    GlobalValidityJob.perform_later(current_user)

    flash[:success] = "We're checking the validity of all of your company's data. You will get an email with "\
                      'the results. This may take a while.'

    redirect_to company_path(@company)
  end
end
