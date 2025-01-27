

### Yet more commonly used Unix commands

**Additional options and applications for commands we covered in the two previous weeks**

* `echo` -- display a line of text   
  The `-e` option interprets escaped characters   
    - `echo -e "You know nothing, Jon Snow.\n\t- Ygritte"`: interprets as RETURN and TAB characters   
    - `echo "You know nothing, Jon Snow.\n\t- Ygritte"`: interprets as a string literal (default)
  
  The `-e` option also interprets Unicode characters   
    - `echo -e "\u03A9"`: use `\u` (lower-case u) to specify a 4-digit Unicode character 
    - `echo -e "\U01F60E"`: use `\U` (upper-case U) to specify a 6-digit Unicode character
    - `echo -e "\U0001F60E"`: also works with 8 digits; left-pad with 0s (useful for scripts)
  
* `grep` -- returns lines matching a pattern  
  To search for a Unicode character, precede with **$** and enclose in **single** quotes
  - `grep $'\u2020' IOC_14.2.csv`: searches for `†`
  
  It is possible to search multiple files at once, including location information   
  - `grep $'\u2020' df1.csv df2.csv df3.csv`: searches for `†` in 3 files; displays file name by default
  - `grep -hn $'\u2020' df1.csv df2.csv df3.csv`: displays only line numbers   
  - `grep -n $'\u2020' df1.csv df2.csv df3.csv`:	displays file name and line numbers
    
  To see lines around matching lines, use upper-case A/B/C options; the number specifies how many lines
  - `grep -A5 $'\u2020' IOC_14.2.csv`: return 5 lines **A**fter each matching line
  - `grep -B10 $'\u2020' IOC_14.2.csv`: return 10 lines **B**efore each matching line 
  - `grep -C5 $'\u2020' IOC_14.2.csv`: return 5 lines before and after each matching line (**C**ontext)
    
  `grep` does not understand logic operators, but you can construct OR and AND searches
  - `grep -e Hoatzin -e Kagu IOC_14.2.csv`: OR; returns lines containing **either or both** patterns
  - `grep $'\u2020' IOC_14.2.csv | grep 'Genus'`: AND; returns lines containing **both** patterns
  - `grep $'\u2020' IOC_14.2.csv | grep -v 'ssp'`: AND NOT; returns lines containing **first but not second** pattern
 
* `sort` -- sorts lines of input
  
  You can sort the lines of a file or input string
  - `sort file.txt`: sorts lines in `file.txt`
  - `echo -e 'foo\nbar\nbaz\nqux' | sort`: requires the `-e` option to separate into multiple lines 

  Default is to sort by character in ascending order, but this can be changed  
  - `sort file.txt`: sorts lines in `file.txt` in alphabetical order
  - `sort -r file.txt`: sorts in reverse
  - `sort -n file.txt`: numeric sort (integers only)
  - `sort -g file.txt`: general numeric sort (includes floats, but slower)
  - `sort -d file.txt`: use only alphanumeric characters and blanks for sorting
  - `sort -f file.txt`: ignore case

  Default behavior is to use the entire line, but this can also be changed
  - `sort -k 3 columns.txt` -- sort from the 3rd field (column) to the end of the line
  - `sort -k 3,3 columns.txt` -- sort on the 3rd field only
  - `sort -k 5,5 -k 3,3 columns.txt` -- sort on the 5th field, then break ties with the 3rd field
 
  Beware that `sort` may use different ordering in different shells  
  - `echo -e 'zebra\nAnkara\nZeus\nant' | sort`: alphabetical with bash on our VMs but not in some other shells!
  - `echo -e '99\nAnkara\n Zeus\n1' | sort`: same as above!
 
  If your sort results are not what you expect:
  - In some shells, `sort` uses ASCII encoding to determine order: whitespace, numerals, upper-case letters, lower-case letters
  - Use the `--debug` option to highlight the field in each line that `sort` is using
  - See [this page](./unx_unexpected_sorting.md) and the [GNU FAQ](https://www.gnu.org/software/coreutils/faq/coreutils-faq.html#Sort-does-not-sort-in-normal-order_0021) if you're still getting unexpected results
 
* `tr` -- translate (substitute), delete, or squeeze characters in input

  Note that, unlike most commands, `tr` will not take a file as an argument; use `cat` or `echo` to send text through a pipe to `tr`.

  Note also that `tr` operates on a character-by-character basis. Use `sed` to manipulate strings (see below).

  The default behavior of `tr` is substitution; this works with special characters and Unicode 
  - `cat IOC_14.2.csv | tr † E`: substitute `†` with `E`
  - `cat IOC_14.2.csv | tr $'\u2020' E`: same result


**New commands**

* `sed` -- sed is a "stream editor", a tool that offers powerful text manipulation capabilities.  For the purposes of this introduction we're going to focus on just one use case -- text substitution.
  - `echo "Hello world, Hello universe" | sed 's/Hello/Goodbye/`: substitute the first occurence of "Hello" with "Goodbye"
  - `echo "Hello world, Hello universe" | sed 's/Hello/Goodbye/'`: substitute the all occurences of "Hello" with "Goodbye" (the `g` at the end of the sed command means "globally")
  - `echo "Hello world, Hello universe" | sed 's/Hello//g'`: delete all occurences of "Hello"

