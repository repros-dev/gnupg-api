#!/usr/bin/env bash

PUBLIC_KEY_FILE=data/public.gpg
PRIVATE_KEY_FILE=data/private.asc
CLEAR_MESSAGE_FILE=data/message.txt
ENCRYPTED_MESSAGE_FILE=tmp/encrypted_message.asc

# ------------------------------------------------------------------------------

bash_cell 'delete the gnupg home directory and keys' << END_CELL

# delete contents of GnuPG home directory for this REPRO
gnupg-runtime.purge-keys

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'import the public key for repro@repros.dev' << END_CELL

python3 << END_PYTHON

import pretty_bad_protocol as gnupg
import os

gpg = gnupg.GPG(homedir=os.environ.get("GNUPGHOME"))

with open("${PUBLIC_KEY_FILE}", "r") as public_key_file:
    public_key_text = public_key_file.read()
gpg.import_keys(public_key_text)

public_keys = gpg.list_keys()
assert len(public_keys) == 1
public_key = public_keys[0]

print("uids        =", public_key['uids'][0])
print("fingerprint =", public_key['fingerprint'])

END_PYTHON

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'list the imported public key' << END_CELL

# list the gpg keys
echo
gpg --list-keys

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'encrypt a file using the public key' << END_CELL

python3 << END_PYTHON

import gnupg
import os

gpg = gnupg.GPG(homedir=os.environ.get("GNUPGHOME"))

with open("${CLEAR_MESSAGE_FILE}", "r") as message_file:
    message = message_file.read()

print(message)

encrypted_message = gpg.encrypt(message, 'A168CC1B1D30CC9D079AD5FEA34F78D2B23714E8')

with open("${ENCRYPTED_MESSAGE_FILE}", "w") as text_file:
    text_file.write(str(encrypted_message))

END_PYTHON

gnupg-runtime.redact-key ${ENCRYPTED_MESSAGE_FILE}

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'import the private key for repro@repros.dev' << END_CELL

# import the private key file
gpg --import --pinentry-mode loopback --passphrase=repro ${PRIVATE_KEY_FILE} 2>&1

# list the gpg keys
gpg --list-keys

END_CELL

# # ------------------------------------------------------------------------------

# #export GPG_TTY=$(tty)

# bash_cell 'decrypt the message encrpted above' << END_CELL

# python3 << END_PYTHON

# import pretty_bad_protocol as gnupg
# import os

# gpg = gnupg.GPG(homedir=os.environ.get("GNUPGHOME"))

# with open("${ENCRYPTED_MESSAGE_FILE}", "r") as encrypted_message_file:
#     encrypted_message = encrypted_message_file.read()

# print(encrypted_message)

# decrypted_data = gpg.decrypt(encrypted_message, passphrase='repro')

# print(dir(decrypted_data))
# print(decrypted_data.status)
# print(decrypted_data.__repr__)


# END_PYTHON

# END_CELL
