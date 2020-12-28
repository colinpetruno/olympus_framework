# Installation

Meettrics so far is a very simple app to set up.

If running into a problem with forking and resque
https://stackoverflow.com/questions/52671926/rails-may-have-been-in-progress-in-another-thread-when-fork-was-called

* `git clone git@github.com:colinpetruno/meettrics_web.git`
* `bundle install`
* `rails db:setup`
* `rails s`
* `./bin/webpack --watch --colors --progress`

### Development seeding & Management

`rake application:db:reset_billing`          # Reset billing to a blank slate for all users

`rake application:db:seed_support_requests`  # Fill out some recent support requests to mess with

### Production tasks

In production environments there are a variety of tasks you may want to setup
in a cron.

##### Portunus
These tasks below will rotate kek and dek keys. DEK keys do not require any
manual changes to work. KEK keys will need new master keys added into 
whichever storage adaptor you decide to use. 

`rake portunus:rotate_deks`                # Rotate DEK keys, reencrypt the data

`rake portunus:rotate_keks`                # Rotate KEK keys, reencrypt the deks
