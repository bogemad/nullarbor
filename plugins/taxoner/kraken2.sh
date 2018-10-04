#!/bin/bash

base="$( cd "$( dirname "$0" )" && pwd )"
. "$base/../common.inc"
. "$base/common.inc"

# will use $KRAKEN_DEFAULT_DB

kraken2 --threads "$cpus" "$read1" \
	--memory-mapping --minimum-base-quality 13 \
	--output - --report "$outfile"

