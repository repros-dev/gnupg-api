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

# read the public key from the file
with open("${PUBLIC_KEY_FILE}", "r") as public_key_file:
    public_key_text = public_key_file.read()

# import the public key and trust it
gpg = gnupg.GPG()
gpg.import_keys(public_key_text)
gpg.trust_keys('D13483D074B46132D15258655434DE21A921F55F', 'TRUST_ULTIMATE')

END_PYTHON

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'list the imported public key using the gpg cli' << END_CELL

gpg --list-keys

END_CELL


# ------------------------------------------------------------------------------

bash_cell 'encrypt a file using the public key' << END_CELL

python3 << END_PYTHON

import gnupg

# read the message from a file
with open("${MESSAGE_FILE}", "r") as message_file:
    message = message_file.read()
print(message)

# use the public key to encrypt the message
gpg = gnupg.GPG()
key = gpg.list_keys().key_map['D13483D074B46132D15258655434DE21A921F55F']
encrypted_message = gpg.encrypt(message, key['keyid'])
print(encrypted_message.status)

# write the encrypted message to a file
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

# read the encrypted message from a file
with open("${ENCRYPTED_MESSAGE_FILE}", "r") as encrypted_message_file:
    encrypted_message = encrypted_message_file.read()

# decrypt the message using the private key
gpg = gnupg.GPG()
decrypted_data = gpg.decrypt(encrypted_message, passphrase='repro')
print(decrypted_data.status)

# print the decrypted message
print()
print(str(decrypted_data))

END_PYTHON

END_CELL
