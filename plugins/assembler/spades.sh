#!/bin/bash

base="$( cd "$( dirname "$0" )" && pwd )"
. "$base/../common.inc"
. "$base/common.inc"

WORKDIR=$(mktemp -d)

echo "# $0"
echo "# $WORKDIR"

# it does not have a --force option
OUTDIR="$WORKDIR/spades"
spades.py --iontorrent -k 21,33,55,77,99,127 -m 32 -o "$OUTDIR" -s "$read1" -t "$cpus" --careful $opts

cp -v -f "$OUTDIR/scaffolds.fasta" "$outdir/contigs.fa"
cp -v -f "$OUTDIR/assembly_graph_with_scaffolds.gfa" "$outdir/contigs.gfa"
cp -v -f "$OUTDIR/spades.log" "$outdir/contigs.log"

rm -frv "$WORKDIR"
