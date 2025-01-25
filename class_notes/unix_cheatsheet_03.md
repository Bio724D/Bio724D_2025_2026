

### More commonly used Unix commands

Some additional options for commands we covered in the two previous weeks

* `echo` -- display a line of text   
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
  - `grep Stegosaurus t1.txt t2.txt t3.txt`: searches for Stegosaurus in 3 files
     
  The following options help locate matching lines by file and by line   
  - `grep -hn Scarlet IOC_14.2.csv`: includes line numbers   
  - `grep -n Scarlet IOC_14.2.csv`:	includes file name and line numbers
    
  These are very useful miscellaneous options for `grep`
  - `grep -i green IOC_14.2.csv`: ignore case
  - `grep -c ORDERS IOC_14.2.csv`: return count of matching lines
  - `grep -v ssp IOC_14.2.csv`: return lines without a match
    
  To see lines around matching lines, use upper-case A/B/C options; the number specifies how many lines
  - `grep -A5 Hoatzin IOC_14.2.csv`: return 5 lines before each matching line (**A**bove)
  - `grep -B10 Hoatzin IOC_14.2.csv`: return 10 lines after each matching line (**B**elow)
  - `grep -C5 Hoatzin IOC_14.2.csv`: return 5 lines before and after each matching line (**C**ontext)
    
  `grep` does not understand logic operators, but you can construct OR and AND searches
  - `grep -e Hoatzin -e Kagu IOC_14.2.csv`: OR; returns lines containing either pattern
  - `grep Red IOC_14.2.csv | grep Falcon`: AND; returns lines containing both patterns
  - `grep Red IOC_14.2.csv | grep -v Falcon`: AND NOT; returns lines containing first but not second pattern   
 
* `tr` -- translate (substitute) or delete characters in input

  Note that unlike most commands `tr` will not take a file as an argument, so typically you would use `cat` to send the contents of a file through `tr` or `echo` to send from STDIN
  - `echo ATGCAA | tr A a`: substitute lower case "a" for uppercase "A"
  - `echo ATGCAA | tr -d A`: delete all "A" characters
  - `echo ATGCAA | tr ATGC TACG`: substitute each character in the first set ("ATGC") with the matching character in the second set ("TAGC")
 
  Pre-defined character can be very useful
  - `cat file.txt | tr [:lower:] [:upper:]`: convert all lower-case letters to uppder-case 

New commands

* `sed` -- sed is a "stream editor", a tool that offers powerful text manipulation capabilities.  For the purposes of this introduction we're going to focus on just one use case -- text substitution.
  - `echo "Hello world, Hello universe" | sed 's/Hello/Goodbye/`: substitute the first occurence of "Hello" with "Goodbye"
  - `echo "Hello world, Hello universe" | sed 's/Hello/Goodbye/'`: substitute the all occurences of "Hello" with "Goodbye" (the `g` at the end of the sed command means "globally")
  - `echo "Hello world, Hello universe" | sed 's/Hello//g'`: delete all occurences of "Hello"

