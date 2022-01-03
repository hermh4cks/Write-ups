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
| Both conditions must be true for the statement to be true | **AND** |  `if x >= 5 **AND** x <= 100` Returns TRUE if x is a number between 5 and 100 |
| Only one condition of the statement needs to be true | **OR** | `if x == 1 **OR** x == 10` Returns TRUE if x is 1 or 10 |
| If a condition is the opposite of an argument | **NOT** | `if **NOT**
