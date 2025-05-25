# Fenwick Tree & Segment Tree Library

A MoonBit library implementing efficient data structures for range query operations and point updates.

## Overview

This library provides two powerful data structures:

1. **Fenwick Tree** (Binary Indexed Tree) - Efficient for prefix sums and point updates in O(log n) time
2. **Segment Tree**

## Fenwick Tree

A Fenwick Tree (also known as Binary Indexed Tree) is a data structure that provides efficient methods for:

- Computing prefix sums in an array
- Updating values in the array
- Querying sum of elements in a range

All operations run in O(log n) time complexity.

### Usage

```moonbit
// Create a new Fenwick Tree of size 10
let tree = @fenwick.FenwickTree::new(10)

// Update values (1-indexed)
tree.update(1, 5)  // Add 5 to position 1
tree.update(3, 2)  // Add 2 to position 3

// Get prefix sums
let sum = tree.prefix(3)  // Sum of elements from 1 to 3

// Get range sums
let range_sum = tree.range(1, 3)  // Sum of elements from 1 to 3

// Get/Set individual values
let val = tree.get(3)     // Get value at position 3
tree.set(3, 10)           // Set position 3 to value 10
```

## Segment Tree

A Segment Tree is a more versatile data structure that allows for:

- Range queries in O(log n) time
- Point updates in O(log n) time
- More complex operations than Fenwick trees
- Immutable data structure

### Usage

```moonbit
// Segment trees operate on ranges
let tree = @fenwick.SegTree::empty() // Create an empty segment tree

// Update and query operations
let updated_tree = tree.update(5, 10)  // Add 10 at index 5
let value = updated_tree.get(5)        // Get value at index 5
let new_tree = updated_tree.set(5, 20) // Set index 5 to value 20
```

## Bits Implementation

This library includes a custom **infinite** bits representation for efficient bit manipulation operations, powering both the Fenwick Tree and Segment Tree implementations.

### Bit Operations

- Basic operations: increment, decrement, shift left/right
- Logical operations: AND, OR, NOT
- Bit testing and manipulation: set/clear bits, test odd/even
- Specialized operations for tree traversal

## Tutorials

There is an article that describes in detail the design methodology of this library and how to derive fenwick trees from segment trees and infinite bit representations:

- [You could have invented Fenwick Trees](https://www.cambridge.org/core/journals/journal-of-functional-programming/article/you-could-have-invented-fenwick-trees/B4628279D4E54229CED97249E96F721D)
- [You could have invented Fenwick Trees (MoonBit + Chinese version)](https://moonbit.community/blog/fenwick/index)
