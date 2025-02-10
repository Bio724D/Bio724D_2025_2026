# The `PATH` variable

The `PATH` environmental variable tells your shell where in your file system to look for executable commands/programs.  

You can see what your current `PATH` setting is by executing:

```bash
env | grep PATH
```

## Modifying your `PATH`

By default your `PATH` is set to include a bunch of standard directories (e.g. `/bin/`, `/usr/bin`, etc.). You can add additional directories to your `PATH` by modifying the `PATH` variable; this is usually done in one of the standard bash startup files.

If you look at your `~/.profile` shell which gets invoked at login (see [Bash Startup Files](./bash-startup.md)) you'll see the following if-blocks:

```bash
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
```

These blocks ask whether there is an existing `$HOME/bin` or `$HOME/.local/bin` folder; if there is than add those directories at the start of the the `PATH` variable (directories are separated by colons).  Unless you have already created one of these sub-directories you won't see either of these location in your `PATH` (as before: `env | grep PATH`)

---

**Note**: `$HOME` is a variable that expands to the current users "home directory"; e.g. `/home/username`)

---

## Adding `~/bin` to your `PATH`

The `~/.profile` on your VM will automatically add `~/bin` to your `PATH` if this directory exists.  That means, if we create an executable program or script and we want to be able to invoke it without specifying the full path you can simply make sure `~/bin` exists and copy your program or script to that location. Let's illustrate this:

1. Create the directory `~/bin`

    ```bash
    mkdir ~/bin
    ```

2. Re-invoke execution of the commands in your `~/.profile` using the `source` command:

    ```bash
    source ~/.profile
    ```

3. Check your `PATH` again; you should see `/home/username/bin` at the front of your `PATH`

    ```bash
    env | grep PATH
    ```

4. Create a test script, `greeter`, and save or copy it to `~/bin`:

    ```bash
    #!/usr/bin/env bash
    echo "Hello! Please to meet you."
    ```

5. Make your script executable:

    ```bash
    chmod +x ~/bin/greeter
    ```

6. You can now invoke your new `greeter` command regardless of where you are on the file system:

    ```bash
    greeter
    ```