# Authentication Models

### Models utilized in authentication and logging in. 

1. Member: This is the core connection model required for individual users.
1. AuthCredential: This model contains the oauth token information needed to
   utilize the respective apis
   - provider (google)
   - member_id
   - token
   - refresh_token
   - expires_at
   - expires
   - family_name
   - given_name
   - image (via activestorage)
   - timestamps
1. AuthCredentialLog: Log of all the tokens utilized via the member
1. Company: The authcredentials and billing are tied to the company.
   - domain: domain of the account which represents the company
   - auth_credential_id: if the company has a company admin connected, this
      field will point to the id of the auth credential with admin access

### Important Classes:

1. Authentication::CredentialsUpdater - every time a renew or token request
     is received via omniauth this is the class to pass the response to in
     order to update the credentials and log the previous credentials
1. Authentication::OauthResponse - pass a response from omniauth to this class
     in order to parse it. This is the adaptor that will forward the hash to
     the apropriate adaptee in order to parse it. 
1. Authentication::Action - determines the action taken after a successful
     omniauth authentication and has the redirect paths and other information
     needed to figure out how to handle the response
