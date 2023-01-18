# Odd or Even

Given a list of integers, determine whether the sum of its elements is odd or even.

Give your answer as a string matching "odd" or "even".

If the input array is empty consider it as: [0] (array with a zero).

**Example**
```
Input: [0]
Output: "even"

Input: [0, 1, 4]
Output: "odd"

Input: [0, -1, -5]
Output: "even"
```

# My Solution:

```python
def odd_or_even(arr):
    # Get total sum of the arry
    total = sum(arr)
    # if the total is 0, return "even"
    if total == 0:
    	return("even")
    # total isn't zero and has no remainder if divided by zero, return "even"
    elif total%2 == 0:
    	return("even")
    # if neither condition is met, the sum is odd, return "odd"
    else:
    	return("odd")
```
