#!/usr/bin/env bash

# ------------------------------------------------------------------------------

bash_cell 'show gpg program version' << END_CELL

gpg --version

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'show gnupg package installation' << END_CELL

pip show gnupg

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'load gnupg python package' << END_CELL

python3 << END_PYTHON

import gnupg
print(gnupg)

END_PYTHON


END_CELL
