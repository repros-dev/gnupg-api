#!/usr/bin/env bash


# ------------------------------------------------------------------------------

bash_cell 'generate a key pair' << END_CELL

# delete contents of GnuPG home directory for this REPRO
gnupg-runtime.purge-keys

# generate a new key pair
python3 << END_PYTHON

import gnupg
import os

gpg = gnupg.GPG(homedir=os.environ.get("GNUPGHOME"))
key_settings = gpg.gen_key_input(
    key_type = 'RSA',
    key_length = 1024,
    name_real = 'repro user',
    name_email = 'repro@repros.dev',
    passphrase = 'repro'
)
key = gpg.gen_key(key_settings)

END_PYTHON

# list the gpg keys
gpg --list-keys | grep uid

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'export the public key' << 'END_CELL'

PUBLIC_KEY_FILE=tmp/public.pgp
rm -f ${PUBLIC_KEY_FILE}

# export the public key
python3 << END_PYTHON

import gnupg
import os

gpg = gnupg.GPG(homedir=os.environ.get("GNUPGHOME"))
public_key = gpg.export_keys('repro@repros.dev')

with open("tmp/public.pgp", "w") as text_file:
    text_file.write(public_key)

END_PYTHON

# print a redacted view of the public key
gnupg-runtime.redact-key ${PUBLIC_KEY_FILE}

END_CELL

# # ------------------------------------------------------------------------------

# bash_cell 'export the private key' << 'END_CELL'

# # export the private key
# PRIVATE_KEY_FILE=tmp/private.asc
# rm -f ${PRIVATE_KEY_FILE}

# # export the public key
# python3 << END_PYTHON

# import gnupg
# import os

# gpg = gnupg.GPG(homedir=os.environ.get("GNUPGHOME"))
# private_key = gpg.export_keys('repro@repros.dev', secret=True, passphrase='repro')

# with open("tmp/private.asc", "w") as text_file:
#     text_file.write(private_key)

# END_PYTHON

# # print a redacted view of the private key
# gnupg-runtime.redact-key ${PRIVATE_KEY_FILE}

# END_CELL
