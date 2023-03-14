# arrayify.nvim

Quickly format arrays and other basic data structures across languages.

## Usage

When the plugin is installed the user can type the :Arrayify command. This will
give the user a prompt where they can array elements pressing enter after 
each element. To print the array the user presses enter on a new empty prompt.

Arrayify only currently supports Arrays in a handful of languages. Look into 
contributing to expand the plugin's functionality.
### Example
In normal mode, move the cursor right before where you want the array.
```
:Arrayify⏎
Element: This⏎
Element: is⏎
Element: an⏎
Element: example⏎
Element: ⏎

```
```
["This", "is", "an", "example"]
```
Numbers or certain keywords typed are automatically formatted without quotes 
based on the programming language being worked on.

```
:Arrayify⏎
Element: One⏎
Element: 2
Element: False⏎
Element: True⏎
Element: five⏎
Element: ⏎
```
```
["One", 2 False, True, "five"]
```

# Installation

Install through any plugin manger. The following example is for vim-plug
```
Plug 'Seth-Buchanan/arrayify.nvim'

```

# TODO

* Make the Arrayify function able to accept an array of strings as an argument instead 
of input for whatever reason people would need that for.

* Make a better way to store syntax info.

* Make a better way to decide when the input is finished so users can input
empty strings.

* Curate the list of keywords that don't get quotes like booleans and None type
variables.

* Look into cleaner methods of file type detection.

* Get rid of the big if else statement for recognizing file types and instead
make the file types the key in a map or something simular.

* Better variable names.

* Expand programming language support.

* Add type cast arrays for languages like Rust and Java. Starting with 
languages that don't allow for mixed data type arrays.

* Add support for different basic data structures i.e.: tuples, array of tuples,
dictionaries, lists, maps.

* Write vim help page.

* Test defaults for implemented languages. The Fortran array is untested.

* Add a way for users to change the standard symbols and symbols for any supported 
language.

* Add better error messages.

## Features to consider

* If the current line is empty, make the array with a placeholder name of "array".

```
array = ["this", "is", "an", "example"] 
```
When the user starts typing the plugin would delete "array" and put the 
user into insert mode.

* Make the data structure multiple lines when it is long or full of 
syntactic fluff. For example, The following is a list of tuples in PowerShell:

```
$myList = New-Object System.Collections.ArrayList

$myList.AddRange((
[Tuple]::Create(1,"string 1"),
[Tuple]::Create(1,"string 2"),
[Tuple]::Create(1,"string 3") 
));
```

* Add import statements in python or other languages when adding a new 
data structure that needs imported.

* Check if there is an equal sign right before cursor if so, prepend a space 
to the output before printing. This would prevent the following:

```
array =["this", "is", "an", "example"] 
```
and instead do 
```
array = ["this", "is", "an", "example"] 
```
* Make the program able to take highlighted text. Arrayify would then split the 
text by spaces and return the correct array.
