
# Package Managers on Linux Systems

Most popular Linux-based operating systems provide a package manager for installing software.  You can think of a package manager as akin to an "App Store", and most Linux desktop environments (e.g. Gnome, KDE) provide a simple point and click software installation interface that is very much like the app stores you are familiar with on Mac OS or Windows.  Since we're working with a remote VM, we'll see how to install software packages from the command line.

On derivates of Debian Linux (which includes Ubuntu, the system we're using on our VMs) the package manager is a tool called `apt`.  We can use the `apt` command to search for software as well as install software.

There are thousands of software packages and libraries available through `apt`.  `apt` includes a basic search subcommand (e.g. `apt search parallel`) but this often returns many hits because it searches both titles and text descriptions of the packages.  So instead of the command line search, I suggest you use the online search interface for Ubuntu, available here: https://packages.ubuntu.com/



### Installing a package using `apt`

Once you know the name of the package you want to, you can use `apt` with the `install` subcommand to install it:

```
sudo apt install zip
```

We invoked `apt` by prefixing it with the `sudo` command ("super user do"). `sudo` is the command line equivalent of saying "invoke the following command with Administrator privileges". For security reasons, installing software "globally" on a Unix-based system requires you have administrative rights on a system (this is generally true on MacOS and Windows too).  You'll be prompted to enter your password (your NetID password in the case of your VM) before the `apt install` subcommand will work.

### Your turn

Use `apt` to search for and install the programs `zip`, `dos2unix`, and `parallel`. 