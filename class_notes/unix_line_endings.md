
# Dealing with different line endings

Different operating systems have historically used different conventions for indicating the end of a line in a file.

* Unix -- unix-based systems used the "line feed" code  (designated `\n`) to indicate the end of a line
* Windows - Windows systems typically used the combination of a "carriage return" (`\r`) and a line (`\n`) to indicate the end of a line. The pair is thus `\r\n`.
* Mac classic - Older Mac systems (OS 9 or earlier) used a single carriage return (`\r`) to indicate the end of lines.

Depending on the tools/commands you're using these different line ending conventions can sometimes be a hinderance. The `dos2unix` command tool we installed previously can help us convert files that follow the Windows and classic Mac conventions to the unix convention (and vice versa).

### Example data

* Download the [Ames et al zip file](https://github.com/Bio724/Bio724-Example-Data/raw/main/Ames-etal-2017-ecy1886-sup-0002-datas1.zip) using `wget`.

* Create a directory where you'll unzip this zip file into: 
  * `mkdir ~/ames-etal-data`)
  
* Switch to that directory 
  * `cd ~/ames-etal-data`

* Unzip the zip file using the `unzip` command (assumes the zip files is in your home directory):
  * `unzip ~/Ames-etal-2017-ecy1886-sup-0002-datas1.zip` 

### Examine the data using less

The Ames et al. data is a set of CSV (comma separated values) files (see the corresponding `*_metadata.txt` files for a description of what's in each file). If you use `less` to examine one of the data files (e.g. `LeafTraits.csv`) you'll see that it appears that all the lines are run together. For example on my screen the first few lines of less look like this:

```
Year,Date,Site,Plot,SpecCode,LeafNumber,Area,Perimeter,Length,Width,FreshMass,DryMass,SLA,LDMC^M2011,7/27/11,1,1,ARISTR,1,1.164,,,,0.040,0.017,68.488,0.425^M2011,7/27/11,1,1,ARISTR,2,1.806,,,,0.060,0.028,64.489,0.467^M2011,7/27/11,1,1,ARISTR,3,1.178
<output truncated>
...
```

The `^M` characters displayed here usually indicate that that Windows line endings are being used, but could also indicate that the older Mac convention (carriage returns only) is used.

### Converting line endings using dos2unix

The `dos2unix` tool helps us deal with line ending conversions (there is a corresponding `unix2dos` command for going the opposite direction).

By default, `dos2unix` will try to convert Windows-to-Unix line endings, modifying a file "in place":

```
dos2unix LeafTraits.csv
```

In most cases this is sufficient to convert a file. If this worked correctly than when we re-examine the file the `^M` carriage-return characters should no longer be displayed.

```
less LeafTraits.csv
```

Unforutnately, it appears that in this case the files may be using the older Mac convention of a carriage return only. Luckily, `dos2unix` can handle this case by specifying a command line option.

```
dos2unix -c mac LeafTraits.csv
```

In this case the `-c` command with the argument `mac` instructs `dos2unix` to treat the file as a having the classic Mac convention.  Now when we open the file in `less` it looks like we expect:


```
Year,Date,Site,Plot,SpecCode,LeafNumber,Area,Perimeter,Length,Width,FreshMass,DryMass,SLA,LDMC
2011,7/27/11,1,1,ARISTR,1,1.164,,,,0.040,0.017,68.488,0.425
2011,7/27/11,1,1,ARISTR,2,1.806,,,,0.060,0.028,64.489,0.467
<output truncated>
...
```


### Converting the line endings of many files at once

Let's apply the same line ending conversion to all the `.csv` files in our working directory:

```
dos2unix -c mac *.csv
```