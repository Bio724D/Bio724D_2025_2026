
# Bash startup files

From the [Bash Manual](https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html)

>When Bash is invoked as an interactive login shell...it first reads and executes commands from the file `/etc/profile`, if that file exists. After reading that file, it looks for` ~/.bash_profile`, `~/.bash_login`, and `~/.profile`, in that order, and reads and executes commands from the first one that exists and is readable. 

>When an interactive shell that is not a login shell is started, Bash reads and executes commands from `~/.bashrc`, if that file exists.. 


Explanation:

* Startup files includes commands and settings that are executed when you start the bash shell (e.g. when you login via the terminal or VS Code) or you invoke a new bash environment.

* Startup files are useful because they allow you to customize your working environment and setup aliases and functions for invoking commonly used commands

## Startup files on your VM

Two startup files that were created by default for your VM -- `~/.profile` and `~/.bashrc`


### `~/.profile`

This startup file is invoked when you login. It's a good place to define or modify environment variables like `PATH` or `LC_ALL`.  I recommend adding the following lines (feel free to leave out the comments) **at the end** of your existing `~/.profile`:

```bash
# the less program invokes any options defined here. 
# -X tells less not to clear the screen when it exits
# this setting also applies to `man` which uses the default
# pager program which in this case is LESS
export LESS=-X  

# use ASCI locale rules for sorting and joining
export LC_ALL=C  
```

 The second and third if-blocks add some specific directories to your `PATH` if they exist (see [Setting the `PATH` variable](./setting-the-path.md)).

### `~/.bashrc`

This file is always invoked for non-login shells (e.g. typing `bash` at the command line invokes a new shell process, but it is no longer a login shell). Note that your `~/.profile` is setup to invoke this for login shells as well.

This is a good place to include [aliases](https://linuxize.com/post/how-to-create-bash-aliases/). If you look through this file you'll see that a number of useful aliases have been pre-defined for you. For example `ll` is an alias for `ls -alF`. Try some of these aliases yourself.