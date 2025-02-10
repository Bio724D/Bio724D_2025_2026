# Bash Syntax and Terminology


You'll recall that a shell is the command line interface by which you interact with the operating system.  Bash (`bash`) is the default shell on most Linux based systems . You can examine which shell you're using by typing:

```bash
echo $SHELL
```

In Unix-derived systems, shells not only interpret the commands you type but also provide idioms for iterating of lists, controlling the flow of execution, etc. In essence, Unix shells are simultaneously user interfaces and programming languages.

This document review key syntax and terminology you'll encounter when you move beyond simply typing single commands in the bash shell.


## Pipelines

* "pipeline" -- a sequence of one or more commands separated by the pipe operator '|'
  * e.g.  `cut -f2 yeast_features.txt | sort`


## Other operators

We've previously seen the pipe (`|`) and redirection (`>`, `<`, `>>`, `<<`) operators. Here are a few other of the most common bash operators

* `cmd1 ; cmd2` -- run commands sequentially; exit status is status of last command
  * e.g. `echo One Two Three; echo A B C`

* `cmd1 && cmd2` -- run `cmd1` and then run `cmd2` if `cmd1` succeeded (exit status 0)
  * e.g. `wget http://example.com/file.gz && gunzip file.gz` -- the `gunzip` command never runs if the example `wget` fails

* `cmd1 || cmd2` -- run `cmd1`, if it fails than run `cmd2`
  * e.g. `cat a_file_name_that_might_not_exist.txt || echo "I couldn't find that file!"`

## Lists

* "list" is a sequence of one or more pipelines separated the `;`, `&&`, and `||` operators.

## Grouping commands

There are two ways to group commands together. In both cases the output of each command is written successively to `stdout`.

* `( list )` -- runs commands in a subshell process

  * e.g. `(echo One Two Three; echo A B C) | cut -f2 -d " "` -- compare what the output is when you leave out the grouping parentheses

* `{ list; }` -- runs commands in current shell process. Note that the final semi-colon is required.

## Parameters and parameter expansion 

From the [Bash Hacker's Wiki](https://wiki.bash-hackers.org/syntax/pe)

>A parameter is an entity that stores values and is referenced by a name, a number or a special symbol.  

* Parameters referenced by a name are called "variables"
  * e.g. `FIRST_NAME="FRED"` set a variable called `FIRST_NAME`
  * case matters: `first_name` is not the same variable as `FIRST_NAME`
* Parameters referenced by a number are called "positional parameters" and reflect the arguments given to a shell (see below)

"Parameter expansion" refers to the procedure of getting the referenced value from a parameter.  The simplest version has the form `${PARAMETER}`


```bash
FIRST_NAME="Fred" 
MIDDLE_INITIAL="F"
LAST_NAME="Foo"
echo "${LAST_NAME}, ${FIRST_NAME} ${MIDDLE_INITIAL}."
```


## Command substitution

Command substitution allows the output of a command to replace the command itself. The syntax is:

* `$(command)`

Some examples:

* ```bash
  echo "Today's date is: $(date +'%b %d, %Y')"
  echo "In ISO-8601 format we'd write that as: $(date -I)"
  ```

* ```bash
  echo "The largest file in your home directory is named: " \
       $(ls -1 --sort=size ~ | head -1)
  ```



### Arithmetic expansion

You can do simple **integer arithmetic calculations** in Bash by wrapping an arithmetic expression ins the form `$((expression))`.

Examples:
```
A=10;B=12; echo "The sum of $A and $B is $((A+B))"
```

But compare the output of the two computations involving division. 

```
A=20;B=5; echo "$A divided by $B is $((A/B))"
```

versus

```
A=20;B=30; echo "$A divided by $B is $((A/B))"
```

What's going on? As emphasized above Bash only does **integer arithmetic**.

```
A=20;B=30; echo "Integer division of $A divided by $B is $((A/B)) remainder $((A%B))"
```

## Sequence expression (Ranges)

A sequence expression generates a range of integers or character values. The syntax is:

```bash
{x..y[...incr]} 
```
Where `x` and `y` are either integers or single characters, and the optional argument `incr` is an integer.

```bash
echo {5..10} # generates the numbers 5 to 10 (inclusive)
```

```bash
echo {5..10..2} # generates the numbers 5 to 10 in increments of 2
```

```bash
echo {100..0..-10} # negative increments work
```

```bash
echo {A..G}  # character ranges
```

```bash
echo {a..g} # lower case character range
```

```bash
# look at an  ascii table to understand this one, e.g. https://www.ascii-code.com/
echo {a..G}  
```

## Process substitution

> Process substitution is a form of redirection where the input or output of a process (some sequence of commands) appear as a temporary file. -- [Bash Hackers Wiki](https://wiki.bash-hackers.org/syntax/expansion/proc_subst)

A process substitution is created by wrapping a pipeline or list of commands in the following syntax:

```bash
<( commands )
```

I find process substitution to be most useful when a program takes multiple inputs and I want to create the inputs themselves from pipelines or compound commands. Here's an example, where I use `parallel` to create all possible combinations of chromosomes and features from an annotation file without having to create intermediate files:

```bash
parallel echo {1} {2} :::: <(cut -f 1 yeast_features.txt | sort | uniq ) :::: <(cut -f 2 yeast_features.txt | sort | uniq)
```

## Looping

Bash has three loop (iteration) constructs -- `for` loops, `while` loops, and `until` loops. Here I discuss only `for` loops which are the most widely used of the three.

### For loops

Syntax:

```bash
for name in [ words ]
do
  [ commands ]
done
```

Meaning:

Expand `[ words ]` as needed and apply `[ commands ]` to each element of the resultant list; the variable `name` gets bound to each element.

Examples:

```bash
# loop over the numbers 1 to 4
for item in {1..4} 
do
  echo ${item} potato!
done
```

```bash
# loop over the .txt files in your current directory
# where the list of files is generated via command subsitution
for filename in $(ls *.txt)
do
  echo ${filename} backward is $(echo ${filename} | rev)
done
```

```bash
# loop over a list of strings
for word in Who What Where When Why How
do
  echo "Newspaper writers are taught to discuss:" $word
done
```

## If and If-else statements

Syntax:

```bash
if [ condition ]; then
  [ commands ]
fi
```

and

```bash
if [ condition ]; then
  [ commands ]
else
  [ other commands ]
fi
```


Meaning:

`if` and `if-else` blocks control the execution of different commands depending on whether particular condition is true. You can add additional conditions through the inclusion of [`elif` blocks](https://linuxconfig.org/bash-if-statements-if-elif-else-then-fi). 


Example:

```bash
# if statement
if [ $(ls -l *.txt | wc -l ) -gt 5 ]; then
  echo "You've got more than 5 text files in your home directory!"
fi
```

```bash
# if-else statement
if [ $(ls -l *.txt | wc -l ) -lt 50 ]; then
  echo "You are text file poor. Better step up your text game!"
else
  echo "You have an abundance of text files in your home directory!"
fi
```

The operators `-gt` ("greater than") and `-lt` ("less than") in these examples are used for arithmetic comparisons. Other arithmetic logical operators include `-eq` ("equal to"), `-le` ("less than or equal to") `-ge` ("greater than or equal to") and `-ne` ("not equal to").

---

**Note**: Some examples you'll find online will wrap the `condition` statement in double brackets like so: `[[ condition ]]`. For discussions of the differences between single and double brackets around conditional statements see [here](https://stackoverflow.com/questions/3427872/whats-the-difference-between-and-in-bash) and [here](https://stackoverflow.com/questions/669452/are-double-square-brackets-preferable-over-single-square-brackets-in-b). 

---


## Other resources

* https://devhints.io/bash -- a nice bash cheat sheet
* https://www.gnu.org/software/bash/manual/ -- the official  bash manual