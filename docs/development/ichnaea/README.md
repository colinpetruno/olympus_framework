# Ichnaea Architecture

## Overview
Ichnaea is our event tracking platform. We like to keep our data as close as 
possible and so Ichnaea acts as our internal store of data. We first will 
record data here and then push to third parties. 

While it's not in place yet, each time we "push" data we should maintain a 
record of it so we can know it's there and delete it at a later date. 

Ichnaea is [highly normalized](https://www.studytonight.com/dbms/first-normal-form.php)
to cram as much data into as little space as possible. Currently Ichnaea stores 
about 3.15MM pageviews per gig. 

## Gem extraction
Ichnaea is intended to be removed from the core code as a gem. 

## Useage

### Event tracking methodology 
We want to keep the number of top level events to a minimum. The goal is to 
utilize the properties of the events to customize the behavior. 

### Tracking page views

We track page views at the very top in application controller. 

```ruby
  # ApplicationController

  def track_page_view
    # try to avoid tracking bots and get requests
    return if Browser.new(request.user_agent).bot?
    return if !request.get?

    Ichnaea::TrackPageviewJob.perform_later(
      session.id.to_s,
      session_info&.profile&.id,
      session_info&.profile&.class&.name,
      {
        request_information: ::Ichnaea::RequestInformation.for(request),
        viewed_at: DateTime.now,
        event_payload: {
          controller: controller_path,
          action: action_name,
          page: "#{controller_path}##{action_name}"
        }
      }.to_json
    )
  end
```

We skip bots and post requests to avoid the noise in the tracking system. 
From there we are going to a fast write of the data to redis by queuing the
job. This keeps the front end snappy while allowing us some time to do some
data normalization in the background. 

The job takes the following argument:
  - The session id - this is to record logged out users
  - The user class id - along with type this is the polymoprhic entry point
    that allows anything to be tracked.  
  - The user class type

### Tracking link clicks & form submissions
Ichnaea uses js to bind directly to forms and links and add a small delay to
attempt to ensure accurate tracking. 

#### Adding Ichnaea to a link
```ruby
  # Add the appropriate data attributes and the rest is taken care of for you.

  link_to(
    ion_icon("card"),
    dashboard_settings_billings_path,
    title: "Billing",
    data: {
      track: true,
      track_description: "Billing - Navbar",
    }
  )
```

#### Adding Ichnaea to a form

```ruby
  simple_form_for(
    [:marketing, @contact_us_request],
    data: {
      track: true,
      track_name: "Contact us form"
    }
  ) do |f|
```

That's it! It's super easy to ensure any required forms or links are tracked.

### Tracking custom events
Sometimes we might want to track something custom. For the most part, it's
better to use backend tracking for this. It's more accurate, there are no ad
blockers, and less JS to load on the front end. 

In JS:
```js
window.Ichnaea.track("event name", { additional: "properties"} )
```

In Ruby:
```ruby
  ::Ichnaea::TrackEventJob.perform_later(
    session.id.to_s,
    ichnaea_user&.id,
    ichnaea_user&.class.name,
    ichnaea_params.merge({
      url: request.referrer,
      request_information: ::Ichnaea::RequestInformation.for(request),
      event_time: DateTime.now
    }).to_json
  )
```

<b>DO NOT</b> invent new tracking event names. These should be given to you 
by marketing to add or the product owner (if that's you.. ignore me). We want
to keep the number of events low and use properties to drill down. 

##  Architecture

### Database Schema
Ichnaea utilizes a highly normalized database to cram as much data into as 
small of an area as possible. We exchange some write speed for storage. The
goal is not necessarily to save costs, but to save space and therefore be able
to search and iterate way more data at a time. 

With other non normalized tracking systems you might be able to search tens
of thousands of records quickly but with Ichnaea that can be tens of millions
of items.

<iframe 
  width="100%" 
  height="500px" 
  style="box-shadow: 0 2px 8px 0 rgba(63,69,81,0.16); border-radius:15px;" 
  allowtransparency="true" 
  allowfullscreen="true" 
  scrolling="no" 
  title="Embedded DrawSQL IFrame" 
  frameborder="0" 
  src="https://drawsql.app/meettrics/diagrams/ichnaea/embed">
</iframe>

Since most of the request is identical from request to request we can pull out
the parts that are frequently repeated (the url, the utm params etc) and 
add those to it's own table. Otherwise we would be duplicating that data per
row. 

This is amazingly helpful when searching for data points. If I want to know 
how many times did a person hit a url, I first query the url table and then the
page views. Because there are only thousands of URL's the search returns quite
quickly. We can then get a count of the rows that match that `url_id`. The
advantage here is there is way less data to search through so that is also fast. 

Just putting the average sized url (~70 characters) on the table will cause 
about the same data storage as Ichnaea uses to store all the data for that 
event.

`Ichnaea::User` is the key to making this work in any project. We can have any
object in the external application mapped to it's own set of events. This once
again is built this way to be normalized and easy to integrate with Rails. 
Since Rails uses a string as the type on the polymorphic relation would cost us
at least 16 bytes (prob 20-24 with overhead). That equates to 16MB over 1MM 
pageviews. One million page views might sound like a lot but it can be hit
suprisingly quick in any sizeable company. Utilizing even an id and a true 
enum field would still take double the space as a single integer. 

### Adaptor pattern for external data
When we export tracking data externally there is obligations to perhaps delete
it under GDPR. The next phase of Ichnaea will be building out the push side of
the system to get events into different visualization tools in a GDPR compliant
manner. 
