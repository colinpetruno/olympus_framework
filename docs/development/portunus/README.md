# Portunus data encryption

Portunus is our encryption engine. It handles encrypting, decrypting and key 
rotation.

### Overview

Portunus is intended to be a flexible DEK & KEK encryption engine that is
dead simple to utilize and maintain. Encryption without rotation is not nearly
as effective as encryption with rotation. Key rotation is a first class 
citizen of Portunus. 

### Key setup

The more master keys the better. Adding multiple master keys accomplishes two
purposes. First, it increases the difficulty to break the encryption. This 
overall is nice, but even one well done key is hard to break. Second, and more
practically, it lowers the amount of data encrypted under each key. The less
data encrypted and the easier key rotation becomes.


### Encrypting a column

#### Specifying data types

### Key rotation


// TODO: it could make sense to have this as the over view section
// then have a useage section
// then have a underlying structure / how its built
