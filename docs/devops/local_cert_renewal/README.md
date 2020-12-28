# Local cert renewal

In order to develop this app you will need an ssl cert for your development 
subdomain. This is in order to receive requests from our external calendar 
providers. This is a short lived cert only lasting 90 days or so. Thus, you 
will need to frequently renew this cert. 

First run ngrok to serve up traffic from http for you development domain.
`bin/ngrok_renew`

Next run the certbot standalone command.
`sudo certbot certonly --standalone --preferred-challenges http -d development.meettrics.com`

The certs should get outputted somewhere like... 
`/etc/letsencrypt/live/development.meettrics.com/fullchain.pem`

Copy these into the project directory or where your `bin/ssl_server` command
can locate them.

You only really need the privkey and the fullchain. These are aliased so be
careful when you copy you find the aliased location in the above directory.