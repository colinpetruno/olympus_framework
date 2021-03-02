# Adding a migration

Adding a migration has a plethora of potential consequences. Ensure to check
this list each time to make sure that nothing is forgotten.

### Encryption

Any data that can identify our users should be encrypted at rest via Portunus.
In some cases like email, we may want to search on that. In those cases, an 
extra column to contain the hash should be added. App seed data and such does
not require encryption. 

### GDPR Compliance

If we are collecting new data, we run into various compliance issues. We may
need to add this data to our exports and data scrubs. Additionally we may need
to update various contracts such as the data processing agreement and privacy
policy.

### Validations

Validations are required for almost every field. Strings should have limits,
integers need high and low bounds. Let's crush those OutOfRange errors! 

### Indexing

Columns that are used for looking up (like `id`) should always be properly
indexed. Any queries need to be using these indexed columns as well. 


### Adding migration checklist

- [ ] Do all columns containing private data have encryption?
- [ ] Do any encrypted columns need indexing via hashing?
- [ ] Were all columns with personal data adding to the GDPR export / scrub?
- [ ] If new personal data is collected, are the privacy and data processing
  agreements updated?
- [ ] Do all new columns contain proper validations?
- [ ] Are validations enforced at the database level (not null, etc)?
- [ ] Are all columns used for searching properly indexed?
