# Webook subscriptions

Calendar providers give webhook notifications for when calendars change. We 
need this to work perfectly to ensure a lower load on background syncing and
permit longer intervals between scheduled syncs. 

There are a few pieces required to make this work for local development. We 
need to set up a certificate to utilize ssl for our local machine. This will
require setting up a web server via nginx and adding the SSL certs (or perhaps
renewing with Certbot). 


### Nginx setup (Mac)
$   brew install nginx

Copy the nginx configuration from the files directory to 
`/usr/local/var/etc/nginx`

You may need to customize the root path once it is outside of the repo. The
root is currently set to `root ~/Projects/application/public;` 

$   brew services restart nginx

### Renew Cert

LetsEncrypt certs are pretty short lived. You may need to renew the cert in
the repo. If you want to do this there are some commented out lines in the
server config of where the certs should go with the default certbot 
installation `brew install certbot`. It might be good to put the certs there
to run the renew. I'll update with steps when we need to renew for the 
first time. 

One thing to note is that for issuing the cert it's important to not have 
nginx running. Essentially the certbot will spin up a server which then listens
to the port. If nginx is there this process fails. At least this is the case
for new issues, but am unsure if this behavior applies to renews. 

### PageKite credentials. 
Pagekite requires a credential file to run. This is stored in ~/.pagekite.rc.
I included an example but removed the key. Just ask and we can share or create
an account for your user. 

### Running the tunnel. 

`bin/pagekite` 

