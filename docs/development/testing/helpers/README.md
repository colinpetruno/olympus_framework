# Testing Helpers
In order to help support testing we provide some helpers to create account and
calendar objects. These helpers can be found here:

[/spec/helpers](https://github.com/colinpetruno/olympus_framework/tree/master/spec/helpers)


### Account Creator Helper
This helper is used to generate session info objects. Session Info is the
class that wraps the member, company and auth info and should be the class 
that gets passed around to various classes to utilize for member info and 
authentication. 

##### Default Session Info

```ruby
default_session_info
```

This will return a valid default session_info to utilize in any test. It uses
colin@meettrics.com as the email and is based on a dummy response from the 
google authentication. 


##### session_info_custom_data

This method is for passing whatever data you want to the test. Below is an
example of the default options provided via the method. Your custom attributes
will perform a deep merge to overwrite just the attributes you want. 

This method will return a new company and member with a random id each time.
This makes it easy to call over and over and generate session info classes
for different companies over and over.

```ruby
session_info_custom_data({
  member: {
    email: "custom_email@example.com)
  },

  company: {
    email_domain: "example.com",
    name: "example.com",
    auth_credential_id: nil,
    open_signups: true,
    provider: "google_oauth2"
  }
})
```
