
# A note on the `sort` command

Sometimes the `sort` command returns data sorted in an order that is unexpected. If you encounter this and have checked your command line to ensure you're specifying the correct field to sort on, the correct field delimiter, etc. than you may be running into this issue addresswed in the document [GNU Coreutils FAQ: Sort does not sort in normal order!](https://www.gnu.org/software/coreutils/faq/coreutils-faq.html#Sort-does-not-sort-in-normal-order_0021)

Here is a small example that illustrates this for a numerical sort. Create the file `test.csv` with the following contents:

```
bob,1.0,10,foo
jim,3.0,11,bar
paul,21.0,12,baz
steve,16,13,qux
```

Now try sorting on the second column, using the standard `-n` argument to do a numeric sort:

```
sort -t, -k 2 -n -r test.csv
```

On a standard Ubuntu VM install, as provided by Duke's VCM service, you likely got this result:

```
steve,16,13,foo
paul,21.0,12,mary
jim,3.0,11,john
bob,1.0,10,fred
```

Note that the line starting with `steve` comes first, even though `16` is less than `21.0`.

To help debug what's going on we can call sort with the `--debug` argument which highlights the field(s) that sort is using:

```
sort -t, -k 2 -n -r --debug test.csv
```

Now the output looks like this:

```
sort: using ‘en_US.UTF-8’ sorting rules
sort: key 1 is numeric and spans multiple fields
steve,16,13,foo
      _____
_______________
paul,21.0,12,mary
     ____
_________________
jim,3.0,11,john
    ___
_______________
bob,1.0,10,fred
    ___
_______________
```

What's going on!  As described in the FAQ above, it looks like the UTF-8 sorting rules are causing the adjacent fields `16` and `13` to be interpretted as a single field. According to the FAQ sorting problems like this are:

>... most often due to having LANG set to ‘en_US.UTF-8’ set in your user environment. At that point sort appears broken because case is folded and punctuation is ignored because ‘en_US.UTF-8’ specifies this behavior


We have two options to fix this:

1) Instead of `-n` use the `-g` (general numeric sort) option to sort which explicitly converts fields to floating point values prior to the sort.  This is slower than the `-n` option but returns the expected results:

    ```
    sort -t, -k 2 -g -r test.csv
    ```

    Yields:

    ```
    paul,21.0,12,mary
    steve,16,13,foo
    jim,3.0,11,john
    bob,1.0,10,fred
    ```
2) Change the `LC_ALL` environment variable as described in the FAQ. For the bash shell you can invoke this command:

    ```
    export LC_ALL=C
    ```

    Now `sort -n` works as expected:

    ```
    sort -t, -k 2 -n -r test.csv
    ```

    returns:

    ```
    paul,21.0,12,mary
    steve,16,13,foo
    jim,3.0,11,john
    bob,1.0,10,fred
    ```    

Of these two options I think the first (using `-g`) is generally preferable and more portable (even though slower) as it doesn't rely on the user to explicitly set an environment variable. 

However, localization settings are useful to know about, especially if you're working in a non-English speaking context.  This response on on StackExchange to the question ["What does "LC_ALL=C" do?](https://unix.stackexchange.com/a/87763) is a nice explanation.
