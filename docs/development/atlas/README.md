# Atlas - The core

Atlas is the core models and functionaliy of the app. Most SaaS apps are going
to use mostly the same core of models. We need users, companies, accounts, 
addresses etc. Atlas models form the core of the app and can be consumed by
any of the domain areas. 

### Schema
<iframe width="100%" 
        height="500px" 
        style="box-shadow: 0 2px 8px 0 rgba(63,69,81,0.16); border-radius:15px;" 
        allowtransparency="true" 
        allowfullscreen="true" 
        scrolling="no" 
        title="Embedded DrawSQL IFrame" 
        frameborder="0" 
        src="https://drawsql.app/meettrics/diagrams/core/embed">
</iframe>

### Concerns

We include a few base concerns that are common to many requirements.

#### Email Validatable

Validate any field as an email address.

Useage:
```ruby
validates :email, email: true
```

#### Not deletable

This will cause the normal rails methods of `delete`, `destroy` and `destroy!`
to not work. It will raise a `NotDeletableError` when these are called.

```ruby
class SomeClass
  include NotDeletable
end
```

#### Routeable

Include this module to easily access rails routes in any class. 

Useage:
```ruby
class SomeClass
  include Routeable

  def my_route_method
    routes.my_rails_helper_path
  end
end
```

#### Uuidable

Generates a uuid string for a field called `uuid` on the model
```ruby
class SomeClass
  include Uuidable
end
```
