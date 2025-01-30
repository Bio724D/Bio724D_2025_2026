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
conda search fastp
conda install fastp
```

4. To leave your current conda environemnt
```
conda deactivate
```


See also the conda docs for more info:

https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html