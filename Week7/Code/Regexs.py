#!usr/bin/env python3

"""Demonstrates some uses of re module for regex"""

__appname__ = "Regexs.py"
__author__ = 'Elin Falla (ef16@ic.ac.uk)'
__version__ = '0.0.1'

# Imports #
import re

my_string = "a given string"

# tells you match was found
match = re.search(r'\s', my_string)
print(match)

# to see the match
match.group()

# this time match = "none" as no numbers in the string
match = re.search(r'\d', my_string)
print(match)

# how to know whether a pattern was matched (remember in this case it only finds the first instance)
MyStr = 'an example'
match = re.search(r'\w*\s', MyStr)  # finds any number of alphanumeric characters followed by whitespace ie. finds "an"

if match:
    print('found a match:', match.group())
else:
    print('did not find a match')

match = re.search(r'2', "it takes 2 to tango")
print(match.group())

match = re.search(r'\d', "it takes 2 to tango")
print(match.group())

match = re.search(r'\d.*', "it takes 2 to tango")
print(match.group())

match = re.search(r'\s\w{1,3}\s', "once upon a time")
print(match.group())

match = re.search(r'\s\w*$', "once upon a time")
print("'", match.group(), "'", sep="") # to print with quotes so can easily see whitespace

# more compact syntax (need to wrap in print to print to console)
re.search(r'\w*\s\d.*\d', 'take 2 grams of H2O').group()

re.search(r'^\w*.*\s', 'once upon a time').group()  # ^ means match from start of sequence only

re.search(r'<.+>', 'This is a <EM>first<EM> test').group()  # <EM>first<EM> because + is greedy
re.search(r'<.+?>', 'This is a <EM>first<EM> test').group()  # <EM>, ? makes + lazy, so it stops at the first instance of a >

re.search(r'\d*\.?\d*', '1432.75+60.22i').group()  # note \. to find literal .

re.search(r'[AGTC]+', 'the sequence ATTCGT').group()  # ATTCGT

re.search(r"\s+[A-Z]\w+\s*\w+", "The bird-shit frog's name is Theloderma asper.").group()  # ' Theloderma asper'


# looking for email addresses in a string
MyStr = 'Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s]+,\s[\w\.@]+,\s[\w\s]+",MyStr)  # note [\w\s] gets any combination of word and space characters
match.group()
# make it more robust (in case - in email)
MyStr = 'Samraat Pawar, s-pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s]+,\s[\w\.-]+@[\w\.-]+,\s[\w\s]+", MyStr)
match.group()

## EXERCISES
# Try the regex we used above for finding names ([\w\s]+) for cases where the person’s name has something unexpected,
# like a ? or a +. Does it work? How can you make it more robust?
MyStr = 'Samraat?+.Pawar, s-pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s\W]+,\s[\w\.-]+@[\w\.-]+,\s[\w\s]+", MyStr)
match.group()

# Translate the following regular expressions into regular English:
# r'^abc[ab]+\s\t\d' = Finds abc, then any non-zero number of a or b, then whitespace then tab then number, starting
# from beginning of sequence only
re.search(r'^abc[ab]+\s\t\d', "abcababbababbbab \t234.").group()  # 'abcababbababbbab \t2'

# r'^\d{1,2}\/\d{1,2}\/\d{4}$' = Finds a date separated by / ie. 1 or 2 numbers/1 or 2 numbers/2 numbers. also only
# finds a whole string due to ^ at start and $ at end
re.search(r'^\d{1,2}\/\d{1,2}\/\d{4}$', "12/1/4000").group()  # 12/1/4000

# r'\s*[a-zA-Z,\s]+\s*' = Finds any number of spaces then any combination of letters, commas and spaces then any spaces
re.search(r'\s*[a-zA-Z,\s]+\s*', "  \t diuh,fhdusASI  .nvdsijalvdisa").group()  # '  \t diuh,fhdusASI  '

# Write a regex to match dates in format YYYYMMDD, making sure that:
# Only seemingly valid dates match (i.e., year greater than 1900)
# First digit in month is either 0 or 1
# First digit in day ≤3

re.search(r'^[12]{1}[09]{1}\d{2}[\.\/]{1}[12]{1}\d{1}[\.\/]{1}[0-3]{1}\d{1}$', "2900/11/34").group()

## END EXERCISES

# Grouping regex patterns using ()
# no grouping
MyStr = 'Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory'
match = re.search(r"[\w\s]+,\s[\w\.-]+@[\w\.-]+,\s[\w\s]+",MyStr)
match.group(0)

# with grouping
match = re.search(r"([\w\s]+),\s([\w\.-]+@[\w\.-]+),\s([\w\s&]+)",MyStr)  # note \s and , excluded
if match:
    print(match.group(0))
    print(match.group(1))
    print(match.group(2))
    print(match.group(3))

# finding all matches
MyStr = "Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory; Another academic, " \
        "a-academic@imperial.ac.uk, Some other stuff thats equally boring; Yet another academic, " \
        "y.a_academic@imperial.ac.uk, Some other stuff thats even more boring"

emails = re.findall(r'[\w\.-]+@[\w\.-]+', MyStr)
for email in emails:
    print(email)

# finding in files
f = open('../Data/TestOaksData.csv', 'r')
found_oaks = re.findall(r"Q[\w\s].*\s", f.read())  # f.read() means string = file f
found_oaks

# groups within multiple matches
MyStr = "Samraat Pawar, s.pawar@imperial.ac.uk, Systems biology and ecological theory; Another academic, " \
        "a.academic@imperial.ac.uk, Some other stuff thats equally boring; Yet another academic, " \
        "y.a.academic@imperial.ac.uk, Some other stuff thats even more boring"

found_matches = re.findall(r"([\w\s]+),\s([\w\.-]+@[\w\.-]+)", MyStr)
found_matches  # returns list of tuples, each tuple is a match and then tuple(0) is first group and tuple(1) is second etc
for item in found_matches:
    print(item)

# extracting text from web pages
import urllib3

conn = urllib3.PoolManager()  # open a connection
r = conn.request('GET', 'http://www.imperial.ac.uk/silwood-park/academic-staff/')
webpage_html = r.data  # read in the webpage's contents

type(webpage_html)  # type is bytes not strings
My_Data = webpage_html.decode()

pattern = r"Dr\s+\w+\s+\w+"
regex = re.compile(pattern)  # example use of re.compile(); you can also ignore case  with re.IGNORECASE
for match in regex.finditer(My_Data):  # example use of re.finditer()
    print(match.group())

# Improve this by:
# Extracting Prof names as well
# Eliminating the repeated matches
# Grouping to separate title from first and second names
# Extracting names that have unexpected characters (e.g., “O’Gorman”, which are currently not being matched properly)

improved_pattern = r"(Dr|Professor)\s+([^'of''in']\S+)\s+(\w+\S?\w+)"
# explanation: dr or prof then space then any non whitespace except 'of' or 'in' (to avoid eg. 'professor of ecology'
# then space then any alphanumeric including up to one non whitespace (allows for O'Connell or Smith-Jones etc)

regex = re.compile(improved_pattern)  # example use of re.compile(); you can also ignore case  with re.IGNORECASE

# use set to find only unique matches (doesn't seem to work with finditer)
matches = set(regex.findall(My_Data))  # example use of re.finditer()

for match in matches:
    print(match[0])  # can't do .group() as now matches are tuples
    print(match[1])
    print(match[2])
    print("-----")

# use re.sub command to replace all tabs with spaces
New_Data = re.sub(r'\t', " ", My_Data)