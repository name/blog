+++
title = "Setting up a key-pair"
date = 2024-10-15
draft = false

[extra]
lang = "en"
toc = true
comment = false
copy = true
math = false
mermaid = false
outdate_alert = true
outdate_alert_days = 120
display_tags = true
truncate_summary = false
featured = false
+++

we're going to explore the process of creating a secure and versatile pgp key pair. openpgp isn't just an encryption tool; it's a decentralized identity system that puts you in control of your digital presence.

## initial setup

begin by installing the appropriate tools for your os:

- windows: gpg4win
- mac: gpgtools
- linux: gnupg.org

this post uses ubuntu and gnupg.

## configuring gpg

before key creation, add the following to your gpg.conf file:

```conf
# enhance privacy
no-emit-version
no-comments
export-options export-minimal

# improve key information display
keyid-format 0xlong
with-fingerprint

# show key validity
list-options show-uid-validity
verify-options show-uid-validity

# restrict to strong algorithms
personal-cipher-preferences AES256
personal-digest-preferences SHA512
default-preference-list SHA512 SHA384 SHA256 RIPEMD160 AES256 TWOFISH BLOWFISH ZLIB BZIP2 ZIP Uncompressed
cipher-algo AES256
digest-algo SHA512
cert-digest-algo SHA512
compress-algo ZLIB
disable-cipher-algo 3DES
weak-digest SHA1
s2k-cipher-algo AES256
s2k-digest-algo SHA512
s2k-mode 3
s2k-count 65011712
```

## leveraging subkeys

we'll utilize openpgp's subkey feature to create a more secure and flexible key setup. subkeys offer specialized functions:

- signing
- encrypting
- authentication

this approach allows for revoking individual subkeys without compromising the master key if necessary.

## master key creation

let's create the master key for our user, char. this key will certify all others:

```bash
char@rack2:~$ gpg --expert --full-gen-key

Please select what kind of key you want:
   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
   (7) DSA (set your own capabilities)
   (8) RSA (set your own capabilities)
   (9) ECC and ECC
  (10) ECC (sign only)
  (11) ECC (set your own capabilities)
Your selection? 8
Then you have to select the attributes of this key. Only the capability Certify.

Possible actions for a RSA key: Sign Certify Encrypt Authenticate
Current allowed actions: Sign Certify Encrypt

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? s

Possible actions for a RSA key: Sign Certify Encrypt Authenticate
Current allowed actions: Certify Encrypt

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? e

Possible actions for a RSA key: Sign Certify Encrypt Authenticate
Current allowed actions: Certify

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? q
```

follow the prompts, opting for a 4096-bit key size for maximum security. for the lifetime of the key, it is always recommended to put one. if this key is lost, and it has been sent to a key server, it will remain there forever valid. put a duration up to 2 years.

```bash
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 4096
Requested keysize is 4096 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 2y
Key does not expire at all
Is this correct? (y/N) y

Let's add details about char's identity:

GnuPG needs to construct a user ID to identify your key.

Real name: Char Blog
Email address: char.blog
Comment:
You selected this USER-ID:
    "Char Blog <char.blog>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? o
```

a window will appear. it will ask you to fill in a pass-phrase to protect the secret keys. choose one long enough that you can memorise easily.
## adding subkeys

with the master key in place, we'll add subkeys for:

- authentication (a)
- signing (s)
- encryption (e)

list your available keys:

```bash
char@rack2:~$ gpg --list-keys

/home/char/.gnupg/pubring.gpg
--------------------------------
pub   rsa4096/12345678 2024-10-15 [C] [expires: 2026-10-15]
uid         [ultimate] Char Blog <char@char.blog>
```

edit to add new subkeys:

```bash
char@rack2:~$ gpg --expert --edit-key 12345678
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Secret key is available.

sec  rsa4096/12345678
     created: 2024-10-15  expires: 2026-10-15  usage: C
     trust: ultimate      validity: ultimate
[ultimate] (1). Char Blog <char@char.blog>

gpg>
```

let's add an encryption key:

```bash
gpg> addkey
Please select what kind of key you want:
   (3) DSA (sign only)
   (4) RSA (sign only)
   (5) Elgamal (encrypt only)
   (6) RSA (encrypt only)
   (7) DSA (set your own capabilities)
   (8) RSA (set your own capabilities)
  (10) ECC (sign only)
  (11) ECC (set your own capabilities)
  (12) ECC (encrypt only)
  (13) Existing key
Your selection? 8

Possible actions for a RSA key: Sign Encrypt Authenticate
Current allowed actions: Sign Encrypt

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? s

Possible actions for a RSA key: Sign Encrypt Authenticate
Current allowed actions: Encrypt

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? q
RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 4096
Requested keysize is 4096 bits
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0) 2y
Is this correct? (y/N) y
Really create? (y/N) y
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

sec  rsa4096/12345678
     created: 2024-10-15  expires: 2026-10-15  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/12345678
     created: 2024-10-15  expires: 2026-10-15  usage: E
[ultimate] (1). Char Blog <char@char.blog>

gpg>
```

repeat for the authentication and signing keys. it'll look something like this:

```bash
sec  rsa4096/12345678
     created: 2024-10-15  expires: 2026-10-15  usage: C
     trust: ultimate      validity: ultimate
ssb  rsa4096/12345678
     created: 2024-10-15  expires: 2026-10-15  usage: E
ssb  rsa4096/12345678
     created: 2024-10-15  expires: 2026-10-15  usage: A
ssb  rsa4096/12345678
     created: 2024-10-15  expires: 2026-10-15  usage: S
[ultimate] (1). Char Blog <char@char.blog>

gpg> save
gpg> quit
```

## export master key

creating a revocation cert is important in the event of theft of the master key:

```bash
char@rack2:~$ gpg --output 12345678.rev --gen-revoke 12345678
```

make sure to keep this in a safe place (offline storage).

now let's save all keys, delete all private keys, then import only the private keys for each subkey so that the master key is set as a stub.

```bash
# export all keys
char@rack2:~$ gpg --export --armor 12345678 > 12345678.pub.asc
char@rack2:~$ gpg --export-secret-keys --armor 12345678 > 12345678.priv.asc
char@rack2:~$ gpg --export-secret-subkeys --armor 12345678 > 12345678.sub_priv.asc

# delete private keys
char@rack2:~$ gpg --delete-secret-key 12345678

# import just the subkeys
char@rack2:~$ gpg --import 12345678.sub_priv.asc

# check this was successful
char@rack2:~$ gpg --list-secret-keys
/home/char/.gnupg/secring.gpg
sec#  rsa4096/12345678 2024-10-15 [C] [expires: 2026-10-15]
uid         [ultimate] Char Blog <char@char.blog>
ssb   rsa4096/12345678 2024-10-15 [E] [expires: 2026-10-15]
ssb   rsa4096/12345678 2024-10-15 [S] [expires: 2026-10-15]
ssb   rsa4096/12345678 2024-10-15 [A] [expires: 2026-10-15]
```

you can now authenticate with ssh, sign your github commits, and encrypt your emails without compromising the master key.

**don't forget to put your key expiry date(s) in the calendar**
