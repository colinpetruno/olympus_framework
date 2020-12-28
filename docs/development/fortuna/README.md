# Fortuna Billing
Fortuna (Latin: Fortūna, equivalent to the Greek goddess Tyche) is the goddess 
of fortune and the personification of luck in Roman religion

## Overview

Fortuna is our billing system.. it is a beast but still a very much work in 
progress. Fortuna represents billing 1.5 in most companies. It mirrors as
much of the data as we need to not have to make external API calls and use
billing in the app directly. 

## Invoicing

Invoicing.. it's a massive pain. U.S. based developers have it easy but for 
people selling to the EU and definitely those that based in the EU, it is 
critical because all money needs tracked via invoices. 

Invoice is the core model of the billing systems. Every transaction will 
require an invoice. How we present that to the customer is up to the end 
developer / application but to stay EU compliant and make accounting easy the
backend will issue one per transaction.

With recurring systems the invoice is often generated pretty late because once
numbered, it is going to be accounted for in the system. In order to avoid
having to invalidate massive amoounts of people that start a payment flow and
bail, we won't make one until after the first successful charge. Other systems
however will need to generate ones before collecting charges. This needs to
be central to how billing is developed to work in all scenarios. 

## Feature System
Fortuna features a system to meter billing useage for your plans.

## Development rake tasks & utilities

### Reset billing rake task
In order to help with billing there is a rake task to reset all billing tables.

`$ bundle exec rake meettrics:db:reset_billing`

This will reset the tables back to a default billing state where no customers
have signed up yet. The data will still be in the stripe test instance but 
that's fine. You can reset the data there but then all the products and such 
would need to get added and setup again.

### Stripe Sync
There are quite a few webhooks that will handle the updates of some of the
static stripe tables (prices, products, vat rates, etc). You can manually 
sync this by using the `Billing::Stripe::Sync` class. 

Import products & prices

`$ Billing::Stripe::Sync.import_products`

Import vat rates

`$ Billing::Stripe::Sync.import_vats`

Import all

`$ Billing::Stripe::Sync.import_all`

## Schema

Billing is hard.. there is a lot going on here and this schema is close to 
final but some of the relations and such could be streamlined. 

The key model is `Billing::Invoices`. Invoices are extremely important in the
EU but not really a thing in the US (which would utilize a receipt, which is
often an invoice). However the system works for both so we are going with the
higher regulation as the standard. 

Essentially for all purchase an invoice has to be made. There is one caveat
that we run into which is that the invoice needs created when services are
delivered / rendered. This works for SaaS products okay since we essentially
deliver the services immediately at payment. However people that sell goods or
perform services after payment, the invoice should be created at the completion
of the service or when services are "rendered". The idea of transactional 
purchases isn't quite implemented but this schema will support it. 

To simplify logic for this first version the assumption is made that the 
invoice is always generated up front and paid for. If services are rendered
later than this is something that will work but needs a bit more dev to be
fully compliant to the spirit of the regulations. This might actually be the
best we can do with Stripe since every charge generates an invoice. They would
need to have some sort of "purchase order" model that could get tied to 
a later generated invoice to handle services delivered after pre payments. 
Shipping goods to a customer is not considered delivered until they get the
shipping confirmation. 

The other key models are `Billing::PaymentIntents` and `Billing::Charges`. An
invoice has a payment intent which has charges attached to those. An invoice
could be paid via multiple charges. 

In order to track billing references there is the `Billing::ExternalId` table.
This standardizes all the external ids and associates them via polymorphic 
relations. The purpose of this is to provide the ability to have multiple
billing providers in the future like `Adyen` and still be able to use the
same schema. Our products, prices, and customers may need tracked externally 
in more than 1 billing system.

`Billing::Details` right now is tracked on a per source (i.e. credit card) 
right now but could be tracked at a company level as well. However the source
seems to be the best and most direct way to access that info. 


<iframe width="100%" 
        height="500px" 
        style="box-shadow: 0 2px 8px 0 rgba(63,69,81,0.16); border-radius:15px;" 
        allowtransparency="true" 
        allowfullscreen="true" 
        scrolling="no" 
        title="Embedded DrawSQL IFrame" 
        frameborder="0" 
        src="https://drawsql.app/meettrics/diagrams/fortunus/embed">
</iframe>

## Upcoming work
- We need to add a provider to the external id column. This should let us move
  to an agnostic billing provider system and integrate other providers like 
  Adyen.
- Cleanup... 

## Vat Requirements
Basic collection of vat details is currently built but the selection engine
of which rate to apply when needs built yet. There are some hooks set up
already. The idea is largely to look it up by a code `US-PA` for Pennsylvania
VAT or perhaps just `NL` for Netherlands since they have 1 rate. There might
need to be an individual / consumer key hooked up to this lookup. 


Read more here:
[https://sufio.com/articles/shopify/taxes/vat-eu-shopify/](https://sufio.com/articles/shopify/taxes/vat-eu-shopify/)
