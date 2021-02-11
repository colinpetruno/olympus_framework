#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# We will use seeding for saving data necessary to run system.
#
email = MailTemplate.create([
        { class_name: 'Devise::Mailer', 
         method_name: 'confirmation_instructions', 
         subject: 'Confirmation instructions', 
         active: 1,
         content: "Welcome <%= @email %>!

You can confirm your account email through the link below:

<%= link_to 'Confirm my account', confirmation_url(@resource, confirmation_token: @token) %>"
    },
    { class_name: 'Devise::Mailer', 
      method_name: 'reset_password_instructions', 
      subject: 'Reset password instruction', 
      active: 1,
      content: "
     Hello <%= @resource.email %>!

Someone has requested a link to change your password. You can do this through the link below.

<%= link_to 'Change my password', edit_password_url(@resource, reset_password_token: @token) %>

If you didn't request this, please ignore this email.
Your password won't change until you access the link above and create a new one.
     "},

   {  class_name: 'Devise::Mailer', 
      method_name: 'unlock_instructions', 
      subject: 'Unlock instructions', 
      active: 1,
      content: "Hello <%= @resource.email %>!

Your account has been locked due to an excessive number of unsuccessful sign in attempts.

Click the link below to unlock your account:

<%= link_to 'Unlock my account', unlock_url(@resource, unlock_token: @token) %>" },

   {  class_name: 'Devise::Mailer', 
      method_name: 'email_changed', 
      subject: 'Email changed', 
      active: 1,
      content: "Hello <%= @email %>!

<% if @resource.try(:unconfirmed_email?) %>
  We're contacting you to notify you that your email is being changed to <%= @resource.unconfirmed_email %>.
<% else %>
  We're contacting you to notify you that your email has been changed to <%= @resource.email %>.
<% end %>"},
{ class_name: 'Devise::Mailer', 
  method_name: 'password_change', 
  subject: 'Password Change', 
  content: " Hello <%= @resource.email %>!

We're contacting you to notify you that your password has been changed." }
])
