
# sed

From the GNU SED manual:

> sed is a stream editor. A stream editor is used to perform basic text transformations on an input stream (a file or input from a pipeline). 

Perhaps the most common use of `sed` is to carry out text substitutions, but it is capable of a wide variety of text filtering and 

Like `grep`, sed works in a line-wise manner, and hence can process very large files on systems with modest amounts of memory.

## sed commands

* A sed program consists of one or more sed commands. A sed command has the following basic form:

```
[addr]X[options]
```

where `X` represents the command, `[addr]` indicates optional lines to operate on, and `[options]` indicates additonal command modifiers.

Some commands are single like the following:

* `p` -- print
* `d` -- delete
* `q` -- quit

Other commands are single letters followed by additional arguments like:

* `a text` -- append text after a line
* `i text` -- insert text before a line
* `s/regex/replacement/[flags]` -- substitute 


See the [GNU sed manual](https://www.gnu.org/software/sed/manual/html_node/sed-commands-list.html#sed-commands-list) for the full list of commands.


## Automatic printing

* By default, every line of input is printed to output. So if you don't specify any commands sed will simply print each line:

    - `sed '' input.txt` --  echos every line to stdout

* With automatic printing on (the default), specifying the print command will cause every line to be doubled:

    - `sed 'p' input.txt` -- every line will get printed twice.

* The `-n` argument to sed silences automatic printing

    - `sed -n '' input.txt` -- every line processed but nothing printed
    - `sed -n 'p' input.txt` -- every line printed just once


## Sed addresses

Addresses in sed are used to select lines on which to execute the corresponding sed command.

[There are three basic ways to specify addresses](https://www.gnu.org/software/sed/manual/html_node/sed-addresses.html#sed-addresses):

* A numeric address -- i.e. a line number
* Regular expressions -- lines that have a regular expression match
* Ranges -- i.e., a range of line numbers or line numbers and regular expressions

Examples:

* Print a specific line, given by number

    - `sed -n '6p' input.txt` -- print line six from the input

* Print a range of lines, given by numeric values or ranges

    - `sed -n '2,5p' input.txt` -- print lines 2 to 5 inclusive
    - `sed -n '2,+4p' input.txt` -- print line 2 and the next 4 lines

* Delete a range of lines

    - `sed '2,5d' input.txt` -- print all lines except 2 to 5 (inclusive)

* Print up to a given line matched by a regular expression and then quit

    - `sed '/Coral/ q' input.txt` -- print all lines until the pattern "Coral" is encountered and then quit.



## Multiple commands

Multiple sed commands can be specified by repeated `-e` calls at the command line or by specificying a script file to read the commands from.

*  `sed -e '1i #Header' -e '5d' -e '7a Hello' input.txt` -- insert a line before the first line, delete the 5th line,  and append a line with "Hello" after the 7th line

* create a file, `myscript.txt` that contains the following

    ```
    # myscript.txt
    1i #Header
    5d
    7a Hello
    ```

    Execute this as: `sed -f myscript.txt input.txt`

