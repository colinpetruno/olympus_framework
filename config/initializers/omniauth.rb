Rails.application.config.middleware.use OmniAuth::Builder do
  google_scopes = %w(
    email
    profile
    https://www.googleapis.com/auth/userinfo.email
    https://www.googleapis.com/auth/userinfo.profile
    https://www.googleapis.com/auth/admin.directory.user
    https://www.googleapis.com/auth/calendar.events
    https://www.googleapis.com/auth/calendar.readonly
    https://www.googleapis.com/auth/calendar.settings.readonly
  )

  provider(
    :google_oauth2,
    Rails.application.credentials.google[:client_id],
    Rails.application.credentials.google[:client_secret],
    scope: google_scopes.join(", "),
    skip_jwt: true
  )
end

