#!/usr/bin/env bash

export DEFAULT_PYTHON_GNUPG_HOME=~/.gnupg

# ------------------------------------------------------------------------------

bash_cell 'use python-gnupg default home directory' << 'END_CELL'

echo Default location for GnuPG home directory: ${DEFAULT_PYTHON_GNUPG_HOME}
echo

# delete GPG home directory in repro home directory if it exists
export GNUPGHOME=${DEFAULT_PYTHON_GNUPG_HOME}
gnupg-runtime.purge-keys

# demonstrate that the home directory does not exist
tree -a ${DEFAULT_PYTHON_GNUPG_HOME}
echo

# unset GNUPGHOME
export GNUPGHOME=

# attempt to list GnuPG keys using python-gnupg
python3 << END_PYTHON
import gnupg
gpg = gnupg.GPG()
gpg.list_keys()
END_PYTHON

# show that the default GnuPG home directory now exists
tree -a ${DEFAULT_PYTHON_GNUPG_HOME}

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'use standard GNUPGHOME variable to specify custom home directory' << 'END_CELL'

export CUSTOM_GNUPGHOME=./tmp/.gnupg
echo Custom location for GnuPG home directory: ${CUSTOM_GNUPGHOME}

# delete custom GPG home directory in demo tmp directory if it exists
export GNUPGHOME=${CUSTOM_GNUPGHOME}
gnupg-runtime.purge-keys

# demonstrate that the custom GnuPG home directory does not exist
tree -a ${CUSTOM_GNUPGHOME}
echo

# attempt to list GnuPG keys using python-gnupg
python3 << END_PYTHON
import gnupg
gpg = gnupg.GPG()
gpg.list_keys()
END_PYTHON

# show that the custom GnuPG home directory now exists
tree -a ${CUSTOM_GNUPGHOME}

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'use constructor argument to specify custom home directory' << 'END_CELL'

export CUSTOM_GNUPGHOME=./tmp/.gnupg
echo Custom location for GnuPG home directory: ${CUSTOM_GNUPGHOME}

# delete custom GPG home directory in demo tmp directory if it exists
export GNUPGHOME=${CUSTOM_GNUPGHOME}
gnupg-runtime.purge-keys

# demonstrate that the custom GnuPG home directory does not exist
tree -a ${CUSTOM_GNUPGHOME}
echo

# unset GNUPGHOME
export GNUPGHOME=

# manually create the (empty) custom directory
mkdir ${CUSTOM_GNUPGHOME}

# specify custom directory when attempting to list GnuPG keys using python-gnupg
python3 << END_PYTHON
import gnupg
gpg = gnupg.GPG(gnupghome='./tmp/.gnupg')
gpg.list_keys()
END_PYTHON

# show that the custom GnuPG home directory now exists
tree -a ${CUSTOM_GNUPGHOME}

END_CELL
