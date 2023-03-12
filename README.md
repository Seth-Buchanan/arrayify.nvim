# arrayify.nvim

Quickly format arrays and other basic data structures across languages.

## Usage

When the plugin is installed the user can type the :Arrayify command. This will
give the user a prompt where they can array elements pressing enter after 
each element. To print the array the user presses enter on a new empty prompt.

Arrayify only currently supports Arrays in a handful of languages. Look into 
contributing to expand the plugin's functionality.
### Example
First move cursor to location where you want the array.
```
:Arrayify⏎
Example: This⏎
Example: is⏎
Example: an⏎
Example: example⏎
Example: ⏎

```
```
["This", "is", "an", "example"]
```
Numbers or certain keywords typed are automatically formatted without quotes 
based on the programming language being worked on.

```
:Arrayify⏎
Example: One⏎
Example: 2⏎
Example: False⏎
Example: True⏎
Example: five⏎
```
```
["One", 2, False, True, "five"]
```

# Installation

Install through any plugin manger. The following example is for vim-plug
```
Plug 'Seth-Buchanan/arrayify.nvim'

```

# TODO

1. Make the Arrayify function able to accept an array of strings as an argument instead 
of input for whatever reason people would need that for.

2. Make a better way to store syntax info.

3. Make a better way to decide when the input is finished so users can input
empty strings.

4. Curate the list of keywords that don't get quotes like booleans and None type
variables.

5. Look into cleaner methods of file type detection.

6. Get rid of the big if else statement for recognizing file types and instead
make the file types the key in a map or something simular.

7. Better variable names.

8. Expand programming language support.

9. Add type cast arrays for languages like Rust and Java. Starting with 
languages that don't allow for mixed data type arrays.

10. Add support for different basic data structures i.e.: tuples, array of tuples,
dictionaries, lists, maps.

11. Write vim help page.

12. Test defaults for implemented languages. The Fortran array is untested.

13. Add a way for users to change the standard symbols and symbols for any supported 
language.

14. Add better error messages.

## Features to consider

1. If the current line is empty, make the array with a placeholder name of "array".

```
array = ["this", "is", "an", "example"] 
```

When the user starts typing the plugin would delete "array" and put the 
user into insert mode.

2. Make the data structure multiple lines when it is long or full of 
syntactic fluff. For example, The following is a list of tuples in PowerShell:

```
$myList = New-Object System.Collections.ArrayList

$myList.AddRange((
[Tuple]::Create(1,"string 1"),
[Tuple]::Create(2,"string 2"),
[Tuple]::Create(3,"string 3") 
));
```

3. Add import statements in python or other languages when adding a new 
data structure that needs imported.

4. Check if there is an equal sign right before cursor if so, prepend a space 
to the output before printing. This would prevent the following:

```
array =["this", "is", "an", "example"] 
```
and instead do 
```
array = ["this", "is", "an", "example"] 
```
