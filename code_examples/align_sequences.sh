#!/bin/bash

mkdir -p aligned_genes

mafft combined_genes/$1.fasta > aligned_genes/$1_aligned.fasta 