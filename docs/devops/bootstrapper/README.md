# Bootstrapper

In order to make this really easy to deploy we should provide a utility to 
bootstrap the environment in a cloud. 

1. This needs to run in development to create the production instance
1. This should work in production as well to manage servers


### Local Flow

- User will open the URL and get a list of providers
- They need to connect to the cloud provider or enter the cloud provider 
  credentials
- Provision the server resources
- Provision the node balancers
- Add DNS A records for the node balancers 
- Deploy the code
- Need to think about the root keys and certs 



### Server flows
- Auto add a server given certain constraints and max budget limitations
- Add a server through the UI, add to node balancers once provisioned and tested
- 


### Things to think about
- should we make a cname for each server resource??? 
- the server resources should only be available through the load balancer and
  intranet / vpn
