#!/usr/bin/env bash


# ------------------------------------------------------------------------------

bash_cell 'default home directory used by gnupg python package' << END_CELL

python3 << END_PYTHON

import gnupg

# initialize a GPG object without any arguments
gpg = gnupg.GPG()

# the default directory for keyrings is ~/.config/python-gnupg
print("gpg.homedir =", gpg.homedir)

END_PYTHON

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'constructor ignores standard GNUPGHOME setting' << END_CELL

python3 << END_PYTHON

import gnupg
import os

# print the current setting of the standard GNUGPGHOME variable
print("GNUPGHOME   =", os.environ.get("GNUPGHOME"))

# construct a GPG object without any arguments
gpg = gnupg.GPG()

# show that GNUGPGHOME variable setting was ignored
print("gpg.homedir =", gpg.homedir)

END_PYTHON

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'explicitly pass value of GNUPGHOME setting to constructor' << END_CELL

python3 << END_PYTHON

import gnupg
import os

# print the current setting of the standard GNUGPGHOME variable
print("GNUPGHOME   =", os.environ.get("GNUPGHOME"))

# construct a GPG object using setting in standard GNUPGHOME variable
gpg = gnupg.GPG(homedir=os.environ.get("GNUPGHOME"))

# show that the GNUGPGHOME variable setting was used
print("gpg.homedir =", gpg.homedir)

END_PYTHON

END_CELL


# ------------------------------------------------------------------------------

bash_cell 'pass unset environment variable to constructor' << END_CELL

# ensure that the GNUPGHOME variable is not set
unset GNUPGHOME

python3 << END_PYTHON

import gnupg
import os

# show that the standard GNUGPGHOME variable is not set
print("GNUPGHOME   =", os.environ.get("GNUPGHOME"))

# initialize a GPG object using the undefined GNUPGHOME variable
gpg = gnupg.GPG(homedir=os.environ.get("GNUPGHOME"))

# show that the default home directory for the gnupg python package was used
print("gpg.homedir =", gpg.homedir)

END_PYTHON

END_CELL
