# Harpocrates GDPR Compliance
Harpocrates (Ancient Greek: Ἁρποκράτης) was the god of silence, secrets and 
confidentiality in the Hellenistic religion developed in Ptolemaic Alexandria.

## Overview
Harpocrates is what we use to help with GDPR exports and data scrubbing.  

## Installaion
This is a straightforward setup. Simply add the following to your 
`ApplicationRecord`
```ruby
include Harpocrates::Base
```

## Usage
Harpocrates introduces two methods to add onto the Rails models.

### Scrubbable
Scrubbable is a way to rewrite the data with fake data. When we do a GDPR 
deletion we don't want to destroy the records completely or we loose the 
ability to gather historical metrics. Instead we will scrub the data so it
exists and can be analyzed but any attempt at getting personal data is going
to result in gibberish or useless data. 

```ruby
class User < ApplicationRecord
  attr_scrubbable :email, :name
end
```

### Exportable
These fields on the model are their data that you want to add to GDPR exports.
Not every field always needs exported and in fact, you probably don't want
most of our data exported, just the personal data / details they entered.

```ruby
class User < ApplicationRecord
  attr_exportable :email, :name
end
```

### Generating an export
In order to generate an export we need to make a PORO that includes the
`Exporter` class from Harpocrates and then define a method on that class
called `structure`. 

```ruby
class ProfileGdprExport
  include Harpocrates::Exporter

  def self.for(profile)
    new(profile)
  end

  def initialize(profile)
    @profile = profile
  end

  def structure
    {
      profile: profile,
      comments: profile.comments
    }
  end
end
```

You can potentially generate various export files and then zip them together
for download. The structure method lets you define the output the end user
will receive of their data for this particular file. Remember, not all data 
needs exported so you can customize exactly what they need. 

Pull the json from the exporter by running
```ruby
exporter = ProfileGdprExport.for(Profile.first)

exporter.export # -> returns a ruby hash of the computed structure values
exporter.export.to_json # -> convert to json for writing
```

## GDPR Scrub
When a user deletes their account or requests it, scrubbing their data is 
ideal wherever we can. 

```ruby
class ProfileGdprScrub
  include Harpocrates::Scrubber

  def self.for(profile)
    new(profile)
  end

  def initialize(profile)
    @profile = profile
  end

  def structure
    {
      profile: profile,
      comments: profile.comments
    }
  end
end
```

## Differing data retention requirements
You could include scrubbable and exportable on the same structure objects. It 
is not currently set up quite to work. Instead of deep transforming the keys
we probably would need to create a `structure_gdpr_output` instance var instead
of keeping the structure and transforming it in place.

It may be tempting to maintain one master exporter but in reality you will most
likely need a few. Some data like billing data needs returned for tax purposes
for many years and that contains some personal data. First properly denormalize
the database to ensure that profile data and the email for the payment is 
duplicated so that you can scrub their app data distinct from the payments
area. 

## Gem extraction & Improvements
This one should get moved to a gem. 

* Add expiration date for data scrubbing and deletion. By making sure we have
timestamps on most of the tables we utilize we can set up field customization
options on the `attr_scrubbable` calls that define how long that data should
exist for. A daily cron can delete data that expires that day then.

## Background job example
It's of course best to do this in a background job because traversing this 
could be quite annoying. In order to help faciliate the export it's advised
to make an export ActiveRecord model that can take the export files. You can
use this record to track status and email / generate the download links. Our
background job looks something like this:

```ruby
class GdprExportJob < ApplicationJob
  queue_as :exports

  def perform(gdpr_expert_id)
    # lookup the model which we are storing the export status on 
    export = GdprExport.find(gdpr_expert_id)
    
    # profile is our key user details model
    profile = export.profile

    exporter = GdprExporter.for(profile)

    # ensure the tmp folder exists, tmp records will be auto cleaned
    Documents::Folder.for("/tmp/gdpr_exports")
    
    # randomize this filename or else you might hit tmp directory collisons
    filename = "#{SecureRandom.uuid}.json"
    full_path = "/tmp/gdpr_exports/#{filename}"

    # write the file to disc
    File.open(full_path, "wb") do |f|
      f.write(exporter.export.to_json)
    end

    # attach the file to our database record with ActiveStorage
    export.export_file.attach(
      io: File.open(full_path),
      filename: filename
    )

    # TODO: send email notification with link
  end
end
```

## Architecture

Harpocrates works by adding two class methods onto each model.
* `self.attr_exportable_fields`
* `self.attr_scrubbable_fields`

### Field configurations
When the app loads, these methods memoize the settings at that point in time
for each field. It will load up an array of either 
`ExportableFieldConfigurer`'s or  `ScrubbableFieldConfigurer`'s. 

#### ScrubbableFieldConfigurer
This class contains how a field is scrubbed. The current settings can 
be found in the [linked file](https://github.com/colinpetruno/olympus_framework/blob/master/app/models/harpocrates/scrubbable_field_configurer.rb#L52-L65). It be great to have this configured in a lambda. There is some 
support stubbed in from Portunus but it hasn't been completely finished yet. 

#### ExportableFieldConfigurer
This one will simply call through the method in order to export the field. 

### Exporting / Scrubbing time
When you generate an export you first define your class as a PORO and include
the approprate module(s) (Exporter and / or Scrubber). These modules include
methods which will do a recursive iteration over the object defined in the
structure method. 

#### Scrubber
The scrubber will call `Profile.find(1).scrub`. Scrub loops over the field
configurations and will update the data to scrubbed. 

#### Exporter
The exporter will call the `export` method. This also will utilize the struct
and then 
