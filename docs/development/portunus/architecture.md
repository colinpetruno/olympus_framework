# Architecture

## Overview

## Installation

## Useage

## Archhitecture

### Schema

Portunus has a simple and straightforward 1 table schema that works in a 
similar way to active storage. The table it uses is 
`portunus_data_encryption_keys`. 

- `encrypted_key` This is the DEK in encrypted form
- `master_keyname` This is the key in order to find the master key 
- `encryptable_type` The table of the data encrypted by this key
- `encryptable_id` The id of the record encrypted by this key

