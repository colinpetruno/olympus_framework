# Localizations

We extensively use localizations to not only ensure our app is easily switched
to other languages but also because they are a unique and powerful feature to
drive dynamic content.


### The 4 key rule

When possible we want to keep keys to 4 places (aside from the language).

Thus
`models.defaults.calendar.name`

The first key is the domain (views, models, controllers etc).

The second key is a namespace in that domain to help further clarify and 
refine. In thise case we have models.defaults. However we could have a key for
the labels or hints. models.labels or model.hints. 

The third key refers to an object type.

The last key is the property.


### Folder structure

- Base
- Models
- Views
- Controllers

