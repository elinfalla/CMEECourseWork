## Week 1 Content

This week we covered:
- UXIX and Linux (command line)
- Shell Scripting
- Git
- LaTeX

**Language(s):** Bash - version 3.2.57(1)

**Dependencies:** imagemagick, evince (MacOS only)

**Installation:** 
- **imagemagick**
	- `brew install imagemagick` (for MacOS)
	- `sudo apt install imagemagick` (for Linux users)
- **evince**
	- `brew install evince` (for MacOS)
	- (pre-installed on Linux)

### Project structure

2 directories:
- **Code** - shell scripts and text docs with answers
- **Data** - data that some scripts are run on
- **Results** - results eg. data manipulation outputs (note: empty)
- (Local repo also contains **Sandbox** with test files)

### File descriptions
#### UNIX

- **UnixPrac1.txt** - Contains answers to the 'UNIX and Linux' Practical

#### Shell scripting

- **Boilerplate.sh** - Simple shell script that prints 'This is a shell script'.
- **TabToCsv.sh** - Takes a tab delimited file as an argument and converts it to a csv file (comma delimited).
- **MyExampleScript.sh** - Assigns "Hello" and "$USER" to variables and prints 'Hello $USER' (ie. Hello elinfalla)
- **CountLines.sh** - Counts the lines in a file and prints it
- **ConcatenateTwoFiles.sh** - Concatenates text files 1 and 2 by overwriting file 3
- **Tiff2Png.sh** - Converts .tif files in directory to .png
- **CompileLatex.sh** - Compiles a pdf from a LaTeX .tex file
- **CsvToSpace.sh** - Converts a comma separated file (csv) to a space separated .txt file
- **Variables.sh** - Reads string from user and sums two integer inputs read from command line
- **FirstExample.tex** - A basic LaTex document
- **FirstBiblio.bib** - A simple reference used in the bibliography of FirstExample.tex

**Author:** Elin Falla, ef16@ic.ac.uk
