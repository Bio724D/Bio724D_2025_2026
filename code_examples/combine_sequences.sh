#!/bin/bash

# Usage: bash combine_sequences.sh gene_name
# Combine all the fasta files for a gene into a single file
# NOTE: assumes the input files are in a directory called `gene_output`

mkdir -p combined_genes
ls gene_output/$1*.fasta | xargs cat  > combined_genes/$1.fasta