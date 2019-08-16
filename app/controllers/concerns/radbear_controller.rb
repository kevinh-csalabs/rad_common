module RadbearController
  extend ActiveSupport::Concern

  included do
    before_action :configure_devise_permitted_parameters, if: :devise_controller?
    before_action :set_raven_user_context
  end

  def validate_active_storage_attachment(record, attribute, file, valid_types, no_redirect = false)
    # TODO: Remove this method and all calls when active storage validations are added (expected in Rails 6)
    return true if file.blank?

    if !file.content_type.in?(valid_types)
      flash[:error] = "File could not be saved. File type must be one of #{valid_types.join(', ')}."
      return false if no_redirect

      if action_methods.include?('edit')
        render :edit
      else
        redirect_to record
      end
      false
    else
      record.send(attribute).attach(file)
      true
    end
  end

  def validate_multiple_attachments(record, model, attributes_and_types)
    # TODO: Remove this method once native active storage validations are implemented

    errors = []
    attributes_and_types.each do |attribute_and_type|
      file = params[model][attribute_and_type[:attr]]
      next if file.blank?

      if file.content_type.in?(attribute_and_type[:types])
        record.send(attribute_and_type[:attr]).attach(file)
      else
        errors << attribute_and_type[:attr].to_s.humanize
      end
    end
    return true if errors.empty?

    flash[:error] = "#{errors.join(', ')} could not be saved due to invalid content types"
    if action_methods.include?('edit')
      render :edit
    else
      redirect_to record
    end
    false
  end

  protected

    def set_raven_user_context
      return unless current_user

      Raven.context.user = { user_id: current_user.id }
    end
end
