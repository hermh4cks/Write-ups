# Friend or Foe?

Make a program that filters a list of strings and returns a list with only your friends name in it.

If a name has exactly 4 letters in it, you can be sure that it has to be a friend of yours! Otherwise, you can be sure he's not...

Ex: Input = ["Ryan", "Kieran", "Jason", "Yous"], Output = ["Ryan", "Yous"]

i.e.

```python
friend ["Ryan", "Kieran", "Mark"] `shouldBe` ["Ryan", "Mark"]
```

# My Solution

```python
def friend(x):
    arr=[] #create an empty array
    for i in range(len(x)): # loop through the given array
        if len(x[i]) == 4: # if any elements of the array have a length of 4
            arr.append(x[i]) # add them to the new array
    return(arr) # return the new array
```
