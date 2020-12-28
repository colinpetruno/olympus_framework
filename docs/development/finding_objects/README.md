# Finding objects

In order to consolidate lookups and prevent lookup logic being spread around
the app, we use a finder class inside the respective module for the model. 

IE Profile -> Profiles::Finder


This has all the lookup logic consolidated and direct profile finding should
be avoided. 

Avoid:
Profile.where()

Prefer:
Profiles::Finder.for(session_info)
