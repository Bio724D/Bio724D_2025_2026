#!/bin/bash

# Note: install seqkit, mafft, and fasttree using conda before running the script
# conda install -c bioconda mafft seqkit fasttree

# Usage: bash conductor.sh input.csv
#
# input.csv should have the following columns: 
#   gene_name, species_name, sequence_ID
# pipeline assumes that the starting FASTA files are named
# corresponding to the species_names in the input.csv file
# and are located in the current directory.


echo "Extracting sequences..."
parallel -r --colsep ',' --header 1 "bash get_sequences.sh {1} {2} {3}" :::: $1

echo "Combining sequences..."
parallel -r --colsep ',' --header 1 "bash combine_sequences.sh {1}" :::: $1

echo "Aligning sequences..."
parallel -r --colsep ',' --header 1 "bash align_sequences.sh {1}" :::: $1

echo "Building trees..."
parallel -r --colsep ',' --header 1 "bash build_trees.sh {1}" :::: $1



