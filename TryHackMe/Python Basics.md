# TryHackMe's Python Basics Lab

## Task 1 Introduction to Python

This Lab will cover basic python programing.
- Variables
- Loops
- Functions
- Data Structures
- If statements
- Files

## Task 2 Hello World

**Sample code**

```python
# This is an Example comment
print("Hellow World")
```
- showing how to comment a line with `#`
- using a `print()`
- showing that anything inside `()` is the output
- and the we use `""` because it is outputting a string

![image](https://user-images.githubusercontent.com/83407557/128368034-8db68f5e-9630-4097-a1c4-57df54badd3f.png)

## Task 6 Shipping Project

```python
"""
    In this project, you'll create a program that calculates the total
    cost of a customers shopping basket, including shipping.

    - If a customer spends over $100, they get free shipping
    - If a customer spends < $100, the shipping cost is $1.20 per kg of the baskets weight

    Print the customers total basket cost (including shipping) to complete this exercise.

"""

customer_basket_cost = 101
customer_basket_weight = 44

# Write if statement here to calculate the total cost
if customer_basket_cost > 100:
  total_basket_cost = customer_basket_cost
else:
  total_basket_cost = customer_basket_cost + (customer_basket_weight * 1.20)

print(total_basket_cost)


```
## Task 8 Bitcoin Project

```python
