# 1) Introuction to Python

**In this room, you will get hands-on with and learn about the scripting programming language Python. Although programming isn't required to succeed in security, it's a great skill to have. As the "Scripting for Pentesters" module demonstrates, being able to program allows you to create security tools and create quick scripts that will aid you in hacking (as well as defending and analysing).**

This room will teach you:

- Variables
- Loops
- Functions
- Data Structures
- If statements
- Files


# 2) Hello World


## comments
```python
# This is an example of a python comment
```


## print() statements
```python
#this example print "Hello World" to the terminal
print("Hello World")
```

# 3) Mathematical Operators

| Operator | Syntax | Example |
| - | - | - |
| Addition | + | 1+1=2 |
| Subtraction | - | 5-1=4|
| Multiplication | * | 10*10=100 |
| Division | / | 10/2=5 |
| Modulus | % | 11%2=0 |
| Exponent | ** | 5**2=25|

## comparison operator

| Symbol | Syntax |
| - | - |
| Greater than | > |
| Less than | < |
| Equal to | == |
| Not Equal to | != |
| Greater than or equal to | >= |
| Less than or equal | <= |

### Tasks

[+] Print the result of 21+43

```python
print(21+43)
```

[+] Print the result of 142-52

```python
print(142-52)
```

[+] Print the result of 10 multiplied by 342

```python
print(342*10)
```

[+] Print the result of 5 squared

```python
print(5**2)
```

# 4) Variables and Data Types

- **String** - Used for combinations of characters, such as letters or symbols

- **Integer** - Whole numbers

- **Float** - Numbers that contain decimal points or for fractions

- **Boolean** - Used for data that is restricted to True or False options

- **List** - Series of different data types stored in a collection


| String | Float | Integer | Boolean | List |
| - | - | - | - | - |
| Title | Rating | Times Viewed | Favorite | Seen by |
| - | - | - | - | - |
| Star Wars | 9.8 | 13 | True | Alice, Bob | 
| Matrix | 8.5 | 23 | False | Charlie | 
| Indiana Jones | 6.1 | 3 | False | Daniel, Evie |

### Tasks

[+]  In the code editor, create a variable called height and set its initial value to 200.
[+] On a new line, add 50 to the height variable.
[+] On another new line, print out the value of height.

```python
height=200
height=height+50
print(height)
```

# 5) Logical and Boolean Operators

## Logical Operators

| Logical Operation | Operator | Example |
| - | - | - |
| Equivalence | == | `if x == 5` |
| Less Than | < | `if x < 5` |
| Less than or equal to | > | `if x <= 5` |
| Greater than | > | `if x > 5` |
| Greater than or equal to | >= | `if x >= 5` |

## Boolean Operators

| Boolean Operation | Operator | Example |
| - | - | - |
| Both conditions must be true for the statement to be true | **AND** |  `if x >= 5 AND x <= 100` Returns TRUE if x is a number between 5 and 100 |
| Only one condition of the statement needs to be true | **OR** | `if x == 1 OR x == 10` Returns TRUE if x is 1 or 10 |
| If a condition is the opposite of an argument | **NOT** | `if NOT y` Returns TRUE if the y value is False |

## Examples

```python

a = 1
if a == 1 or a > 10:
	print("a is either 1 or above 10")
```
```python
name = "bob"
hungry = True
if name == "bob" and hungry == True:
	print("bob is hungry")
else if name == "bob" and not hungry:
	print("bob is not hungry")
else:
	print("Not sure who this is or if they are hungry")
```

# 6) Intro to If statements

Let's a program to decide based on a condition.

## Example

```python
if age < 17:
	print('you are NOT old enough to drive')
else:
	print('you are old enough to drive')
```

# 7) Loops

in programming loops allow programs to iterate and perform actions a number of times. The two types of loops are `for` and `while` loops.

## While Loops

Can be used to run indefinately or to stop based on a condition

```python
i = 1
while i <= 10:
	print(i)
	i=i+1
```
This while loop will run 10 times, outputting the value of the i variable each time it iterates(loops). These steps can be broken down as follows:

- The i variable is set to 1

- the while statement specifies where the start of the loop should begin

- Every time it loops. it will start at the top(outputting the value of i)

- Then it goes to the next line in the loop, which increases the value of i by 1

- Then (as there is no more code for the program to execute), it goes to the top of the loop, starting the process over again

- The program will keep on looping until the value of the i variable is greater than 10

## For loops

A for loop is used to iterate over a sequence such as a list. Lists are used to store multiple items in a single variable, and are created using square brackets (see below). Let's learn through the following example:

```python
websites = ["facebook.com", "google.com", "amazon.com"]
for site in websites:
	print(site)
```

This for loop shown in the code block above, will run 3 times, outputting each website in the list. Let's break this down:

 - The list variable called websites is storing 3 elements
    
 - The loop iterates through each element, printing out the element
    
 - The program stops looping when it's been through each element in the loop


## Range function

*In Python, we can also iterate through a range of numbers using the range function. Below is some example Python code that will print the numbers from 0 to 4. In programming, 0 is often the starting number, so counting to 5 is 0 to 4 (but has 5 numbers: 0, 1, 2, 3, and 4)*

```python
for i in range(5):
	print(i)
```

# 8) Introduction to Functions

*As programs start to get bigger and more complex, some of your code will be repetitive, writing the same code to do the same calculations, and this is where functions come in. A function is a block of code that can be called at different places in your program.*

*You could have a function to work out a calculation such as the distance between two points on a map or output formatted text based on certain conditions. Having functions removes repetitive code, as the function's purpose can be used multiple times throughout a program.*

```python

# Our function
def sayHello(name):
	print("Hello" + name + "! Nice to meet you.")


# Calling our function

sayHello("Bob") # Output is: Hello Bob! Nice to meet you

sayHello("Alice") # Output is: Hello Alice! Nice to meet you


```

## Key Components to a function

- The `def` keyword indicates the start of a function

- This is followed by the `name` that the programmer defines (sayHello) in the above example

- Following the function name is a pair of parenthesis `()` that holds input values; data that we can pass into the function (name in the above example)

- A colon `:` marks the end of a function header

*In the function, notice the indentation. Similar to `if` statements, anything after the colon that is indented is considered part of the function.*

*A function can also return a result, see the code block below*

```python
def calcCost(item):
	if(item=="sweets"):
		return 3.99
	elif (item == "oranges"):
		return 1.99
	else:
		return 0.99

spent = 10
spent = spent + calcCost("sweets")
print("You have spent:" + str(spent))
```

# 9) Files


## Reading a file

*To open the file, we use the built-in open() function, and the "r" parameter stands for "read" and is used as we're reading the contents of the file. The variable has a read() method for reading the contents of the file. You can also use the readlines() method and loop over each line in the file; useful if you have a list where each item is on a new line. In the example above, the file is in the same folder as the Python script; if it were elsewhere, you would need to specify the full path of the file.*

```python
f = open("file_name", "r")
print(f.read())
```
## Writing/Appending a file

*You can also create and write files. If you're writing to an existing file, you open the file first and use the "a" in the open function after the filename call (which stands for append). If you're writing to a new file, you use "w" (write) instead of "a". See the examples below for clarity:*

```python
f = open("demofile1.txt", "a") #Append to an existing file
f.write("The file will include more text...")
f.close()

f = open("demofile2.txt", "w") # Creating and writing to a new file
f.write("demofile2 file created, with this content in!")
f.close()
```

# 10) Imports

*In Python, we can import libraries, which are a collection of files that contain functions. Think of importing a library as importing functions you can use that have been already written for you. For example, there is a "date" library that gives you access to hundreds of different functions for anything date and time-related.*

```python
import datetime
current_time = datetime.datetime.now()
print(current_time)
```

*We import other libraries using the `import` keyword. Then in Python, we use that import's library name to reference its functions. In the example above, we `import datetime`, then access the `.now()` method by calling `library_name.method_name().` Copy and paste the example above into the code editor.*

## Useful imports as a pentester

- **requests** - simple HTTP library

- **Scapy** - send, sniff, dissect and forge network packets

- **Pwntools** - a CTF & exploit development library

## pip

Many of these libraries are already built into the programming language; however, libraries written by other programmers not already installed in your machine can be installed using an application called pip, which is Python's package manager. Let's say you want to install the "scapy" library (which allows you to craft your own packets in code and send them to other machines); you install it first by running the command `pip install scapy`, after which in your program you can now import the scapy library.
