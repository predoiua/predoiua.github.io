---
layout: post
date:   2015-12-30 12:00:00
categories: security
---
* will be replace by toc
{:toc}

# Security

## Access Control

### Authentication(Identity)

### Authorization(Access Management)

AKA
- Permission


## SSO: Single Sign On

## HMAC: Keyed-Hashing for Message Authentication

https://tools.ietf.org/html/rfc2104.html

- Providing a way to check the integrity of information transmitted
- Typically, message authentication codes are used between two parties that share a secret key in order to validate information transmitted between these parties.

- Function
       ipad = the byte 0x36 repeated B times
       opad = the byte 0x5C repeated B times.

To compute HMAC over the data `text' we perform

    H(K XOR opad, H(K XOR ipad, text))


## Logout 
 - Revocation

## Share key
 - 

Token
- User
    - id
    - display name
- Metadata
    - issue-at
    - expires


OAuth Actors
- client
- Authorization Server
- Resource Server API
- Resurce Ower



