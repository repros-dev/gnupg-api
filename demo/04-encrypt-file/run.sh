#!/usr/bin/env bash

PUBLIC_KEY_FILE=data/public.gpg
PRIVATE_KEY_FILE=data/private.asc
MESSAGE_FILE=data/message.txt
ENCRYPTED_MESSAGE_FILE=tmp/encrypted_message.asc

# ------------------------------------------------------------------------------

bash_cell 'delete the gnupg home directory and keys' << END_CELL

# delete contents of GnuPG home directory for this REPRO
gnupg-runtime.purge-keys

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'import the public key for repro@repros.dev' << END_CELL

python3 << END_PYTHON

import gnupg
import os

gpg = gnupg.GPG()

with open("${PUBLIC_KEY_FILE}", "r") as public_key_file:
    public_key_text = public_key_file.read()
gpg.import_keys(public_key_text)

public_keys = gpg.list_keys()
assert len(public_keys) == 1
public_key = public_keys[0]
gpg.trust_keys(public_key['fingerprint'], 'TRUST_ULTIMATE')

END_PYTHON

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'list the imported public key using gpg command' << END_CELL

# list the gpg keys
echo
gpg --list-keys

END_CELL


# ------------------------------------------------------------------------------

bash_cell 'encrypt a file using the public key' << END_CELL

python3 << END_PYTHON

import gnupg
import os

gpg = gnupg.GPG()

gpg.import_keys_file("${PUBLIC_KEY_FILE}")
public_key = gpg.list_keys()[0]

with open("${MESSAGE_FILE}", "r") as message_file:
    message = message_file.read()
print(message)

key = gpg.list_keys().key_map['D13483D074B46132D15258655434DE21A921F55F']
keyid=key['keyid']

encrypted_message = gpg.encrypt(message, keyid)
print(encrypted_message.status)

with open("${ENCRYPTED_MESSAGE_FILE}", "w") as text_file:
    text_file.write(str(encrypted_message))

END_PYTHON

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'import the private key for repro@repros.dev' << END_CELL

# import the private key file
gpg --import --pinentry-mode loopback --passphrase=repro ${PRIVATE_KEY_FILE} 2>&1

# list the gpg keys
gpg --list-keys

END_CELL

# ------------------------------------------------------------------------------
bash_cell 'decrypt the message encrpted above' << END_CELL

python3 << END_PYTHON

import gnupg

gpg = gnupg.GPG()

with open("${ENCRYPTED_MESSAGE_FILE}", "r") as encrypted_message_file:
    encrypted_message = encrypted_message_file.read()

decrypted_data = gpg.decrypt(encrypted_message, passphrase='repro')

print(decrypted_data.status)
print()
print(str(decrypted_data))

END_PYTHON

END_CELL
