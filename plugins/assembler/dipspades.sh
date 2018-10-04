#!/bin/bash

base="$( cd "$( dirname "$0" )" && pwd )"
. "$base/../common.inc"
. "$base/common.inc"

WORKDIR=$(mktemp -d)

# THIS IS FOR DIPLOID FUNGAL GENOMES

echo "# $0"
echo "# $WORKDIR"

# it does not have a --force option
OUTDIR="$WORKDIR/dipspades"
dipspades.py --iontorrent -k 21,33,55,77,99,127 -o "$OUTDIR" -s "$read1" -t "$cpus" $opts

# dipspades creates 2 subfolders - we just take the 'consensus contigs'
cp -v -f "$OUTDIR/dipspades/consensus_contigs.fasta" "$outdir/contigs.fa"
cp -v -f "$OUTDIR/dipspades/dipspades.log" "$outdir/contigs.log"

# cleanup
rm -frv "$WORKDIR"
