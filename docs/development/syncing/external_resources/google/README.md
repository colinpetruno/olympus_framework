# Google External Resources

### Setup

Google is a big pain when it comes to their API. Much of it is auto generated
and dynamically programmed. In order to use their api it takes many layers
to properly utilize it. 


### Class Stucture

ExternalResources::Google::Base - This class is the top level connection and
most abstracted. It contains the most basic connection information but by 
itself is quite useless.

ExternalResources::Google::Calendars::Base - This class is the base that 
specifies the service class to use for the API. Each distinct API domain for
google needs this type of base class in order to ensure we instantiate the 
correct api class in ruby. 

ExternalResources::Google::Calendars::List - This class is what actually will
do the bulk of the lifting. It inherits the service class from the domain area
(i.e. calendar) base class and the connection instantiation from the Google
base class.
