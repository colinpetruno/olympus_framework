# Soteria Two Factor Authentication
In Greek mythology, Soteria (Σωτηρία) was the goddess of safety and salvation, 
deliverance, and preservation from harm. Soteria was also an epithet of the 
goddess Persephone, meaning deliverance and safety.

In our app it is our two factor authentication systems which keep us safe from
harm and hackers. You can also use 2FA for a reliable audit log of when 
people perform specific actions on your site

## Overview
Soteria currently supports two types of authentication types:
* Mobile authenticator apps
* Auth tokens (usb / fingerprint devices etc)

It could very easily be extended into one time login passwords and mobile text
confirmations although particulary the latter has associated costs involved
for the application.

## Installation / Setup

#### Configure the webauthn setup initializer
```ruby
WebAuthn.configure do |config|
  # This value needs to match `window.location.origin` evaluated by
  # the User Agent during registration and authentication ceremonies.
  config.origin = if Rails.env.production?
                    "https://www.meettrics.com"
                  else
                    "http://localhost:3000"
                  end

  # Relying Party name for display purposes
  config.rp_name = "Meettrics"
end
```

### Configure your AuthenticatedController
```ruby
class SomeController
  before_action :check_two_factor_auth

  # actions and such

  private

  # This will check for a recent auth and request auth if it's been too long
  # without a previous auth
  def check_two_factor_auth
    if two_factor_auth_status.needs_authed?
      session[:two_factor_redirect_url] = request.url
      redirect_to new_auth_two_factor_session_path and return
    else
      session[:two_factor_last_activity] =  DateTime.now.utc.to_i
    end
  end

  # This method will allow you to redeem tokens in controller actions
  def require_token_redemption
    auth_log = TwoFactorAuthLog.where(
      auth_status: :succeeded,
      member: current_member,
      authed_on: (DateTime.now - 5.minutes)..DateTime.now,
      redeemed_at: nil
    ).find_by!(two_factor_redemption_params)

    auth_log.update!(
      redeemed_at: DateTime.now,
      redeemed_by: [controller_path, action_name].join("#")
    )
  end

  # sanitize params
  def two_factor_redemption_params
    params.require(:two_factor_redemption).permit(:id)
  end
end
```

#### Add fields to your login model
Whichever models utilized for login need their secrets added to their records.
* `webauthn_id` - Used for token authenticators
* `otp_secret` - Used for "one time passwords" (mobile texts, 
  mobile authenticators etc)

## Useage

### Getting someones current 2FA status
You can use the Status class to get the current 2FA state from the session.

```ruby
  status = TwoFactorAuthentications::Status.for(current_member, session)

  status.status # -> :authed, :reauth, :not_required
  status.needs_authed? 
```
By default this checks for activity in the last 30 minutes. We could add some
toggles to require it regardless and force them into reauthing or extract
that to a config option.

### Require 2FA in a part of the site
Sometimes you want to make sure the user goes through a recent 2FA flow before
they can access settings like a billing page. To do this just add the following
```ruby
class Controller
  before_action :check_two_factor_auth
end
```

### Add 2FA to a form
In order to enable for any form we only need to add these two lines to the
data attributes of the form. The controller is the stimulus controller and the
path is the url of the endpoint to hit for stimulous. 

The stimulus action will intercept the form submission and handle the auth
in a modal. Once getting a successful auth the backend will insert and return
a short lived token that can be inserted into the form. The action you are 
posting to needs to ensure that the before_action to redeem the token is
also in place. That method will then do a return if it can't find a recent
valid token to redeem for that action. 
```
data: {
  controller: "authentication--redemptions",
  new_session_path: new_auth_two_factor_session_path(format: :js)
}
```

#### As a button_to
Button two needs a bit different structure than a form. 

```ruby
button_to(
  "Delete",
  admin_support_company_companies_deletion_path(@company),
  form: {
    data: {
      controller: "authentication--redemptions",
      new_session_path: new_auth_two_factor_session_path(format: :js)
    }
  },
  class: "button outline primary"
)
```

#### Add token redemption controller logic
Once your form asks for a 2fa token, the next step is to ensure that the 
controller action will check for and redeem the token. In order to do that,
simplay add `require_token_redemption` to the action.

```ruby
  def update
    require_token_redemption

    # continue your action here
  end
```

### Require password confirmation
<strong>NOTE:</strong> This is not 2FA but we can use it if needed to create
another layer of security in the UI. It works by declaring a window of time
they can go do more actions in. By default it is set to 10 minutes. This is 
good for places like billing where you might want to ensure a screen doesn't
get left open too long (although the 2fa above can do the same). 

```
class Controller < AuthenticatedController
  before_action -> (redirect_url = new_auth_password_authentication_path) do
      require_password_confirmation(redirect_url)
  end
end
```
The url is the path that you want the user to return to after they authenticate
with their password.

## Architecture

2FA hits pretty much every tech imaginable we utilize. Stimulus controllers
for the front end, PKI for token authenticators, ajax actions with JS, 
session storage. Thus it can take awhile to track down and understand it all.

// more details to come
