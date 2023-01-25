# Abbreviate a Two Word Name

Write a function to convert a name into initials. This kata strictly takes two words with one space in between them.

The output should be two capital letters with a dot separating them.

It should look like this:

Sam Harris => S.H

patrick feeney => P.F


# My Solution

```python
def abbrev_name(name):
	a = name.split()
	firstname = a[0]
	lastname = a[1]
	initials = f"{firstname[0]}.{lastname[0]}"
	return(initials.upper())
```
