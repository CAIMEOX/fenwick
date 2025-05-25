///|
/// A Fenwick Tree (also known as a Binary Indexed Tree) is a data structure that provides 
/// efficient methods for prefix sums and point updates in an array.
type FenwickTree Array[Int]

///| 
/// Returns the Least Significant Bit (LSB) of an integer.
/// 
/// The LSB is important for Fenwick Tree operations as it determines the range 
/// covered by each position in the tree.
/// 
/// # Arguments
/// - i: The integer to find the LSB for
/// 
/// # Returns
/// The value of the least significant bit of i
fn FenwickTree::lsb(i : Int) -> Int {
  i & -i
}

///| 
/// Creates a new Fenwick Tree with the specified length.
/// 
/// # Arguments
/// - len: The size of the Fenwick Tree
/// 
/// # Returns
/// A new FenwickTree instance
pub fn FenwickTree::new(len : Int) -> FenwickTree {
  Array::new(capacity=len)
}

///| 
/// Computes the sum of elements from index 1 to i.
/// 
/// # Arguments
/// - i: The upper bound of the range (inclusive)
/// 
/// # Returns
/// The sum of all elements in positions 1 to i
pub fn prefix(self : FenwickTree, i : Int) -> Int {
  let mut i = i
  let mut s = 0
  while i > 0 {
    i -= FenwickTree::lsb(i)
    s += self._[i]
  }
  s
}

///| 
/// Adds a value to the element at position i and updates the tree accordingly.
/// 
/// # Arguments
/// - i: The index to update (1-indexed)
/// - delta: The value to add to the current value
pub fn update(self : FenwickTree, i : Int, delta : Int) -> Unit {
  let mut i = i
  while i < self._.length() {
    self._[i] += delta
    i += FenwickTree::lsb(i)
  }
}

///| 
/// Computes the sum of elements from index i to j (inclusive).
/// 
/// # Arguments
/// - i: The lower bound of the range
/// - j: The upper bound of the range
/// 
/// # Returns
/// The sum of elements in positions i through j
pub fn range(self : FenwickTree, i : Int, j : Int) -> Int {
  self.prefix(j) - self.prefix(i - 1)
}

///| 
/// Gets the value at a specific index.
/// 
/// # Arguments
/// - i: The index to query (1-indexed)
/// 
/// # Returns
/// The value at position i
pub fn get(self : FenwickTree, i : Int) -> Int {
  self.range(i, i)
}

///| 
/// Sets the value at a specific index.
/// 
/// # Arguments
/// - i: The index to update (1-indexed)
/// - value: The new value to set
pub fn set(self : FenwickTree, i : Int, value : Int) -> Unit {
  self.update(i, value - self.get(i))
}
