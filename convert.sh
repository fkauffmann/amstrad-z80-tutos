#!/bin/sh

#
# This file is just an example of how ABASC and IMG utilities can be called to convert
# a PNG image to SCN and generate a color palette .info file
#

python3 ../../abasc-1.2.1/src/utils/img.py ./images/screen1.gif --format scn --mode 1
python3 ../../abasc-1.2.1/src/utils/img.py ./images/screen2.gif --format scn --mode 1

mv ./images/screen1.scn .
mv ./images/screen2.scn .
