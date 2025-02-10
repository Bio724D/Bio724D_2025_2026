
# Bash scripts

## Writing shell scripts

Shell scripts are small programs written in the language of the shell; they're convenient for tying together a series of commands that you might otherwise type by hand into a repeatable and documented set of operations. Bash scripts also allow us to write new commands or programs that can be used in a manner similar to other "built-in" programs we've been using.

## Bash scripts are picky

One annoying feature of bash scripting is that it's particularly picky about white space around commands and arguments, because essentially it tries to execute each line as if it was written at the command line itself ([see](https://uvesway.wordpress.com/2013/03/11/some-whitespace-pitfalls-in-bash-programming/)). When following the examples below I recommend you be careful to follow the spacing I've used to avoid hard to diagnose syntax errors.  For this reason, bash is *not* my preferred scripting environment. However it's so ubiquitous in bioinformatics that it's worth learning the basics of bash.

## Simple script examples

### Simple shell script 01

Let's start with the simplest possible shell script -- one that simply writes a message to `stdout`.

Put the following code into a file named `tut01.sh`:

```bash
# tut01.sh
echo "Hello, shell world!"
```

Now you can call your shell script as so from the command line (assuming it's in your current working directory)

```bash
bash tut01.sh
```

This one line script simply called the `echo` command line tool to write text to `stdout`.

### Simple shell script 02

That's a pretty boring shell script.  Let's create a new version that takes as input an argument telling it what to print after the initial greeting. `$1` is how we designate the first argument from the command line.  

```bash
# tut02.sh
echo "Hello, $1"
```

This expects an argument from the command line, so run this script as follows, substituting `Paul` as appropriate:

```bash
bash tut02.sh Paul
```

### Simple shell script 03

Shell scripts can create variables to hold the output of commands. This is illustrated below in which we create a variable `input_reversed` to hold the value of a computation done on the first argument to the script:

```bash
# tut03.sh
# note that rev command reverses lines of input
input_reversed=$(echo $1 | rev) 
echo "$1 reversed is $input_reversed"
```

And we again run it as:

```bash
bash tut03.sh "Twas brillig and the slithey toves..."
```

Notice that I wrapped the text in quotes.  What happens if you don't include the quotes?

### Simple shell script 04

We can get multiple arguments from the command line:

```bash
# tut04.sh
echo "The first argument was: $1"
echo "The second argument was: $2"
```

Or we can check the number of arguments:

```bash
# tut04a.sh
nargs=$#

if [[ $nargs -ne 2 ]]
then
    echo "I need two arguments!"
    exit
fi

echo "The first argument was: $1"
echo "The second argument was: $2"
```



## Different ways of using Bash scripts 

### Reproducibility

- Did your analysis require a bunch of different steps? Could you reproduce what you did? Could you teach someone else to do it?

- Put each of the steps of your analysis into a bash script and save the file with a `.sh` ending. You or someone else can replicate your analysis by running `bash yourscriptname.sh`. Consider saving all such scripts you create for reproducibility purposes to a git repository.

Example: 

```bash
# yeast_feature_counts.sh
#
# Purpose: count feature types in yeast genome annotation GFF file
# Output: a CSV table sorted by freq of feature

wget -q https://ftp.ncbi.nlm.nih.gov/genomes/refseq/fungi/Saccharomyces_cerevisiae/reference/GCF_000146045.2_R64/GCF_000146045.2_R64_genomic.gff.gz

gunzip GCF_000146045.2_R64_genomic.gff.gz

awk -F"\t" -v OFS="," \
    'NF == 9 {cts[$3] += 1}
    END {for (ftr in cts) 
            print ftr, cts[ftr] }' \
    GCF_000146045.2_R64_genomic.gff |
sort -t, -k 2 -nr 
```

You can execute this script by calling it as an argument to bash:

```bash
bash yeast_feature_counts.sh > yeast_features.csv
```

### Reusability

- You developed a pipeline to solve one instance of a problem. Is this a type of computation you do repeatedly or are likely to do in the future on different inputs?

- Create a bash script "template" by re-writing the script to include variables for specifying input and output file name, key parameters, etc.

```bash
# feature_count_template.sh
#
# Purpose: count feature types in any GFF annotation
# output a CSV table sorted by freq of feature

# --- REPLACE THESE VARIABLES --- #

GFF_URL=""  # RefSeq URL Location
OUT_DIR="output"  # Directory for output, will be created if necessary

# -- END USER DEFINED VARIBLES -- #

# Create output directory if it doesn't exist
if [ ! -e ${OUT_DIR} ]; then
    mkdir -p ${OUT_DIR}
fi

# intermediate files written to OUT_DIR
gff_gz=${OUT_DIR}/gff.gz
gff_file=${OUT_DIR}/features.gff

# download and unzip the data if 
if [ ! -f ${gff_file} ]; then
    wget ${GFF_URL} -O ${gff_gz}
    gunzip ${gff_gz} -c > ${gff_file} 
fi

# run the analysis sending the results to stdout
awk -F"\t" -v OFS="," \
    'NF == 9 {cts[$3] += 1}
    END {for (ftr in cts) 
            print ftr, cts[ftr] }' \
    ${gff_file}  |
sort -t, -k 2 -nr 
```

If you, or someone you gave the script to, wanted to use this to run the analysis on another organism you would make a copy:

```bash
cp feature_count_template.sh ecoli_feature_count.sh
```

modify the `GFF_URL` and `OUT_DIR` lines appropriately:

```bash
# ecoli_feature_count.sh
#
# Purpose: count feature types in E coli genome
# Output: a CSV table sorted by freq of feature

GFF_URL="https://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Escherichia_coli/reference/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.gff.gz"  

OUT_DIR="Escherichia_coli"

... <rest of template stays the same...>
```


and then run the script:

```bash
bash ecoli_feature_count.sh
```


### Encapsulation and Abstraction

- You developed a pipeline that carries out a useful computation that you want to integrate into other analyses or pipelines

- Use a bash script to turn your pipeline into a command that can be integrated into other pipelines, following the Unix philosophy.  From the user's perspective, you can think of this as "abstracting away" the details of how the analysis works.  They no longer have to understand the details of how the program or command works, they simply have to know what data to call it with and the form of the output. 

    Here we achieve this in a very simple way -- by  providing a way for our script to process arguments provided at the command line.

    ```bash
    #!/usr/bin/env bash
    # feature_count.sh -- download a GFF file from RefSeq and 
    #   count the feature types

    nargs=$#

    if [ $nargs -ne 2 ]; then
        echo "usage: $0 URL OUTDIR"
        exit 1
    fi

    GFF_URL=$1  # RefSeq URL Location
    OUT_DIR=$2  # Directory for output, will be created if necessary

    # Create output directory if it doesn't exist
    if [ ! -e ${OUT_DIR} ]; then
        mkdir -p ${OUT_DIR}
    fi

    # intermediate files written to OUT_DIR
    gff_gz=${OUT_DIR}/gff.gz
    gff_file=${OUT_DIR}/features.gff

    # download and unzip the data if 
    if [ ! -f ${gff_file} ]; then
        wget ${GFF_URL} -O ${gff_gz}
        gunzip ${gff_gz} -c > ${gff_file} 
    fi

    # run the analysis sending the results to stdout
    awk -F"\t" -v OFS="," \
        'NF == 9 {cts[$3] += 1}
        END {for (ftr in cts) 
                print ftr, cts[ftr] }' \
        ${gff_file}  |
    sort -t, -k 2 -nr 
    ``` 

Make this script executable (`chmod +x feature_count.sh`). You can call it directly from your working directory or add it to your `PATH`.  Having done this you can  use this script by specifying a URL and a directory name to write the output files to. Since the URL is long I assign it to a variable:

```bash
celegans_url=https://ftp.ncbi.nlm.nih.gov/genomes/refseq/invertebrate/Caenorhabditis_elegans/reference/GCF_000002985.6_WBcel235/GCF_000002985.6_WBcel235_genomic.gff.gz
```

And then call the bash script

```bash
feature_count.sh $celegans_url celegans
```

#### Back to reproducibility

By encapsulating our pipeline we've made it reusable and generalizable to analyses of arbitrary GFF annotation files.  However, we've lost an element of reproducibility because we're no longer documenting the data sources used when we invoke it at the command line.  Luckily it's easy to restore that with -- you guessed it -- another bash script!

To illustrate this, let's assume we wanted to compare feature counts across multiple  genomes. Let's put species names and corresponding RefSeq URLs in a CSV file called `genomelist.csv`:

```csv
Saccharomyces_cerevisiae,https://ftp.ncbi.nlm.nih.gov/genomes/refseq/fungi/Saccharomyces_cerevisiae/reference/GCF_000146045.2_R64/GCF_000146045.2_R64_genomic.gff.gz
Escherichia_coli,https://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Escherichia_coli/reference/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.gff.gz
Caenorhabditis_elegans,https://ftp.ncbi.nlm.nih.gov/genomes/refseq/invertebrate/Caenorhabditis_elegans/reference/GCF_000002985.6_WBcel235/GCF_000002985.6_WBcel235_genomic.gff.gz
```

Now we can generate feature counts for each genome by creating a bash script called `multi_species_count.sh` that includes a call to `parallel`:


```bash
# multi_species_count.sh

parallel --colsep="," 'mkdir -p {1}; ./feature_count.sh {2} {1} > {1}/ftrcounts.csv' :::: genomelist.csv
```

and run this as:

```bash
bash multi_species_count.sh
```

For each species name in your input list, there should now be a corresponding directory that contains a `ftrcounts.csv` file with the respective counts:

```bash
$ ls -1 */ftrcounts.csv
Caenorhabditis_elegans/ftrcounts.csv
Escherichia_coli/ftrcounts.csv
Saccharomyces_cerevisiae/ftrcounts.csv
```

In terms of reproducibility, our full analysis now requires three files:

1. The `feature_count.sh` script
2. The list of genomes we're processing: `genomelist.csv`
3. Our `multi_species_count.sh` that processes the information in (2)  through the pipeline in (1)

There is a slight increase in complexity versus our single species script, but with the following advantages:

1. It's trivial to extend our analysis to include new species/genomes of interest -- we simply add additional species names and URLs to `genomelist.csv`

2. We can run this analysis efficiently for many genomes at once by adding the argument `--jobs=n` to the call to `parallel` where `n` is the number of threads we want to run simultaneously (assuming that you have access to a multi-CPU machine or a compute cluster)


## Other resources

The above is a short intro to bash scripting. Some other useful resources include:

* https://linuxconfig.org/bash-scripting-tutorial-for-beginners -- provides a good overview of bash
* https://www.shellscript.sh/ -- an in-depth tutorial on bash scripting