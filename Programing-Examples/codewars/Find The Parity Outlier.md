# Find The Parity Outlier

You are given an array (which will have a length of at least 3, but could be very large) containing integers. The array is either entirely comprised of odd integers or entirely comprised of even integers except for a single integer N. Write a method that takes the array as an argument and returns this "outlier" N.

# Examples

```python
[2, 4, 0, 100, 4, 11, 2602, 36]
Should return: 11 (the only odd number)

[160, 3, 1719, 19, 11, 13, -21]
Should return: 160 (the only even number)
```

# My Solution

```python
def find_outlier(integers):
	even=0
	odd=0
	for i in range(len(integers)):
		if integers[i]%2==0:
			even+=1
			found_even=integers[i]
		else:
			odd+=1
			found_odd=integers[i]
	if even > odd:
		return(found_odd)
	else:
		return(found_even)
```
