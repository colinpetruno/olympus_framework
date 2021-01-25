# Installation

Olympus so far is a very simple app to set up.

If running into a problem with forking and resque
https://stackoverflow.com/questions/52671926/rails-may-have-been-in-progress-in-another-thread-when-fork-was-called

* `git clone git@github.com:colinpetruno/olympus_framework.git`
* `bundle install`
* `rails db:setup`
* `rails s`
* `./bin/webpack --watch --colors --progress`

### Development seeding & Management

`rake application:db:reset_billing`          # Reset billing to a blank slate for all users

`rake application:db:seed_support_requests`  # Fill out some recent support requests to mess with

### Running Tests

We are using `rspec` to run cases, we are using Rails credentials to store our keys. So before running test cases. You can run all tests using following command.

`bundle exec rspec`

If you get errros in running test. You can edit credentials of test environment using following command
`rails credentials:edit --environment test`

If you get error `Couldn't decrypt config/credentials/test.yml.enc. Perhaps you passed the wrong key?` then remove test credentials by using command `rm config/credenitals/test.yml.enc`  and run again `rails credentials:edit --environment test` and copy sample configuration from `config/example.en.yml` or from `development environment` and save it.

Then change credentials accordingly. In case you get error you can delete `rm config/credentials/test.yml.enc` and then edit again with sample configuration provided in config. `config/example.en.yml`


### Production tasks

In production environments there are a variety of tasks you may want to setup
in a cron.

##### Portunus
These tasks below will rotate kek and dek keys. DEK keys do not require any
manual changes to work. KEK keys will need new master keys added into 
whichever storage adaptor you decide to use. 

`rake portunus:rotate_deks`                # Rotate DEK keys, reencrypt the data

`rake portunus:rotate_keks`                # Rotate KEK keys, reencrypt the deks
