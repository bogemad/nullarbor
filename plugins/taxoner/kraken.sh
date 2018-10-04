#!/bin/bash

base="$( cd "$( dirname "$0" )" && pwd )"
. "$base/../common.inc"
. "$base/common.inc"

# will use $KRAKEN_DEFAULT_DB

kraken --threads "$cpus" "$read1" \
	| kraken-report \
	> "$outfile"
