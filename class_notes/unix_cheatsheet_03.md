

### More commonly used Unix commands

Some additional options for commands we covered in the two previous weeks

* ` echo` -- display a line of text   
  The `-e` option interprets escaped characters   
    - `echo -e "You know nothing, Jon Snow.\n\t- Ygritte"`: interprets as RETURN and TAB characters   
    - `echo "You know nothing, Jon Snow.\n\t- Ygritte"`: interprets as string literal   
  The `-e` also interprets Unicode characters   
    - `echo -e "\u03A9"`: use `\u` (lower-case u) to specify a 4-digit Unicode character 
    - `echo -e "\U01F60E"`: use `\U` (upper-case U) to specify a 6-digit Unicode character 
  Enclose a command in `$( )` to insert the result in the output (command substitution)  
    - `echo "on" $(date) $(pwd) "contained" $(ls -la | wc -l) "files"`   

* `grep` -- returns lines matching a pattern
  It is possible to search multiple files at once   
  - `grep Stegosaurus t1.txt t2.txt t3.txt`: searches for Stegosaurus in 4 files   
  The following options help locate matching lines by file and by line   
  - `grep -hn Scarlet IOC_14.2.csv`: includes line numbers   
  - `grep -n Scarlet IOC_14.2.csv`:	includes file name and line numbers
  These are miscellaneous but must-know options for `grep`
  - `grep -i green IOC_14.2.csv`: ignore case
  - `grep -c ORDERS IOC_14.2.csv`: return count of matching lines
  - `grep -v ssp IOC_14.2.csv`: return lines without a match
  To see lines around matching lines, use upper-case A/B/C options
  - `grep -A5 Hoatzin IOC_14.2.csv`: return 5 lines before each matching line (**A**bove)
  - `grep -C5 Hoatzin IOC_14.2.csv`: return 5 lines after each matching line (**B**elow)
  - `grep -C5 Hoatzin IOC_14.2.csv`: return 5 lines before and after each matching line (**C**ontext)
  `grep` does not understand logic operators, but you can construct OR and AND searches
  - `grep -e Hoatzin -e Kagu IOC_14.2.csv`: OR search; returns lines containing either pattern
  - `grep Red IOC_14.2.csv | grep Falcon`: AND search; returns lines containing both patterns
  - `grep Red IOC_14.2.csv | grep -v Falcon`: AND NOT search; returns lines containing both patterns   
 
* `tr` -- translate or delete characters
    Translate means character-for-character substitution

New commands

* `date` -- returns the date-time
  - `date`: returns a full report, e.g., Tue Jan 21 06:25:17 AM EST 2025 
  - `date -I`: returns just the date, in ISO-8601 format
  - `date +%D`: returns just the date, in Linux format
  - `date +%D:%H:%M`: returns the date, hours, and minutes (+ notation provides many options) 
  - `date -s`: seconds since 1970:01:01:00:00

* `cut` -- removes sections (bytes, characters, or fields) from input
  - For this example create a file (`columns.txt`) with the following command (`\t` = TAB character, `\n` = newline character): 
    `echo -e 'one\ttwo\tthree\nfour\tfive\tsix' > columns.txt`
  If you open the file you will see it is formatted like this:
    ```
    one     two     three
    four    five    six
    ```
  The syntax for specifying columns is quite flexible:
  - `cut -f 2 columns.txt`: get the second column (`cut` assumes columns are separated by tabs by default)
  - `cut -f1,3 columns.txt` get first and third column
  - you can also specify bounded ranges: e.g., `-f2-5` returns columns 2 through 5
  - or open ranges: e.g., `-f-3` returns columns 1 through 3, and `-f5-` returns 5 through the last column
  - column specifications can be mixed (e.g., -f-3,6,9- returns columns 1, 2, 3, 6, and 9 through the last column  
  Because cut assumes a TAB-delimited file, you will need to specify any other delimiter explicitly
  - `cut -f2,7 -d"," df1.csv`: removes columns 2 and 7 from a comma-separated file

* `paste` -- merge corresponding lines from inputs
  - `paste columns.txt columns.txt`
  - `tac columns.txt | paste columns.txt -`: the dash (`-`) here specifies that input should come from stdin. Can you guess what the command `tac` does?
  - `paste -s columns.txt`: The `-s` command merges lines within the file. This gives us behavior that is like the inverse of the `fold` command we saw previously.

* `fold` -- wrap lines to the specified with, printing to stdout
  - `fold -w 5 file.txt`:
  - `echo 12345 | fold -w 1`

* `sed` -- sed is a "stream editor", a tool that offers powerful text manipulation capabilities.  For the purposes of this introduction we're going to focus on just one use case -- text substitution.
  - `echo "Hello world, Hello universe" | sed 's/Hello/Goodbye/`: substitute the first occurence of "Hello" with "Goodbye"
  - `echo "Hello world, Hello universe" | sed 's/Hello/Goodbye/'`: substitute the all occurences of "Hello" with "Goodbye" (the `g` at the end of the sed command means "globally")
  - `echo "Hello world, Hello universe" | sed 's/Hello//g'`: delete all occurences of "Hello"

* `ln` -- make links between files.  Typically you'll want to create "symbolic links" (symlinks), which act like "shortcuts" on Windows systems. Links are useful to create references to files located nested deep in directory hierarchies or with long and tedious names. 
    - Example: 

        ```
        ln -s ~/data/saccharomyces_cerevisiae_R64-5-1_20240529.gff ~/analysis/yeast.gff
        ```
