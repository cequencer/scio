#!/bin/bash

set -e

if [ $# != 3 ]; then
    echo "Usage: $0 <scio-directory> <beam-directory> <commit>"
    exit 1
fi

READLINK="readlink -f"
[[ "$(uname -s)" == "Darwin" ]] && READLINK="greadlink -f"
scio=$($READLINK $1)
beam=$($READLINK $2)
commit=$3
patch="$scio/${commit}.patch"

cd $scio
git format-patch --stdout $commit~1..$commit | sed -e 's/scio-\([a-z]*\)/sdks\/scala\/\1/g' > $patch

cd $beam
git am --reject $patch

rm $patch
