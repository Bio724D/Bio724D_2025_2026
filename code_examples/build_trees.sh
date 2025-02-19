#!/bin/bash

mkdir -p gene_trees
FastTree < aligned_genes/$1_aligned.fasta > gene_trees/$1.nwk