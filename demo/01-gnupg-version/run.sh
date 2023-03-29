#!/usr/bin/env bash

# ------------------------------------------------------------------------------

bash_cell 'show gpg program version' << END_CELL

gpg --version

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'show python-gnupg pip installation' << END_CELL

pip show python-gnupg

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'show python-gnu python package information' << END_CELL

python3 << END_PYTHON

import gnupg
print("Version:", gnupg.__version__)
print("Date:", gnupg.__date__)
print("File:", gnupg.__file__)

END_PYTHON


END_CELL
