#!/bin/bash

base="$( cd "$( dirname "$0" )" && pwd )"
. "$base/../common.inc"
. "$base/common.inc"

# --mm = memory mapped so multiple runs can share the DB
# --time = report time used

centrifuge --mm --time -p "$cpus" -x "$CENTRIFUGE_DEFAULT_DB" -U "$read1" $opts \
	| centrifuge-kreport -x "$CENTRIFUGE_DEFAULT_DB" \
	> "$outfile"
