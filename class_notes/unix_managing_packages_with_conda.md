# Conda

[Conda](https://docs.conda.io/en/latest/) is a "package manager" tool that was originally designed for the Python ecosystem but has be generally adopted as

Package managers are tools for installing/uninstalling software tools, code libraries, and creating computing environments that provide specific functionality.  One of the powerful aspects of Conda is that it allows users to install and use specific version of software packages in isolated or "sandboxed" environments.  This allows users to highly customize their computing environments without impacting other users of the same system.


## Steps to install conda

1. Download the "miniconda" binary 
```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
```

2. Run the installer and follow the prompts
```
bash Miniconda3-latest-Linux-x86_64.sh
```

3. Make the conda tools available from the command line by sourcing your shell profile file or logging off and logging back on


4. Setup software "channels" for common bioinformatics tools

```
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
```

## Creating a conda environment

1. Activate the default (base) conda environment
```
conda activate
```

2. Create a new environment (here named "genomics") 
```
conda create -n genomics
```

3.  Activate a specific environment
```
conda activate genomics
```

3. When working in an environment you can search for and install other tools using `conda search` and `conda install`

```
conda search seqkit
conda install seqkit
```

Now the [seqkit](https://bioinf.shenwei.me/seqkit/) program is available to you, but just in the `genomics` environment:

```
seqkit stats --help
```

Note that seqkit has many subcommands like `stats`, `seq`, `grep`, etc. See the [seqkit documentation](https://bioinf.shenwei.me/seqkit/#subcommands) for info and examples.


4. To leave your current conda environment
```
conda deactivate
```

Since you should now be back in your base environment, seqkit is no longer available:

```
seqkit stats --help  # should generate a command not found error
```


## Listing your available conda environments

Typically one creates different conda environments for different types of pipelines or tasks.  To remind yourself of the conda environments you've created:

```
conda env list
```


See also the conda docs for more info:

https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html