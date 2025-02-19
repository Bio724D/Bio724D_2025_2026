#!/bin/bash
# Usage: bash get_sequences.sh gene_name species_name sequence_ID

mkdir -p gene_output
seqkit grep -r -p $3 $2.fasta > gene_output/$1_$2_$3.fasta