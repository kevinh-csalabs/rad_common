class UserSearch < RadCommon::Search
  def initialize(params, current_user)
    @current_user = current_user

    super(query: User.joins(:user_status).includes(:user_status, :security_roles),
          filters: filters_def,
          sort_columns: sort_columns_def,
          params: params,
          current_user: current_user)
  end

  private

    def filters_def
      items = [{ column: 'first_name', type: RadCommon::LikeFilter, input_label: 'First Name' },
               { column: 'last_name', type: RadCommon::LikeFilter, input_label: 'Last Name' },
               { column: 'email', type: RadCommon::LikeFilter, input_label: 'Email' },
               { input_label: 'Status',
                 column: :user_status_id,
                 options: UserStatus.not_pending.by_id,
                 default_value: UserStatus.default_active_status.id }]

      if RadicalConfig.external_users? && current_user.internal?
        items.push({ input_label: 'Type', name: :external, scope_values: %i[internal external] })
      end

      items
    end

    def sort_columns_def
      items = [{ label: 'Name', column: 'first_name, last_name' },
               { column: 'email' },
               { label: 'Signed In', column: 'current_sign_in_at' },
               { label: 'Created', column: 'users.created_at', direction: 'desc', default: true },
               { label: 'Status', column: 'user_statuses.name' },
               { label: 'Roles' }]

      items.push(label: 'External?', column: 'users.external') if RadicalConfig.external_users?

      items
    end
end
