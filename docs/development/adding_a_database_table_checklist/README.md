# Adding a database table

When a database table is added we should perform the following checklist to 
ensure that we accomodate everything.

- Does this model need to include NotDeletable?
  - If it can be used for analytics or is more than a cache storage we should
    add this module so that we don't accidently delete records and skew metrics
- What fields need to be encrypted? 
  - We need to look at each field and check for PII data and ensure they are
    encrypted.
- Are all app level validations applied
- Would it be better to use a UDID in the URL? 
