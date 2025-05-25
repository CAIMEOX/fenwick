typealias List[T] = @immut/list.T[T]

///|
/// Represents a segment tree, a tree data structure used for storing information about intervals, or segments.
/// - `Empty`: Represents an empty segment tree.
/// - `Branch(Int, Range, SegTree, SegTree)`: A node in the segment tree with a value, a range, and two children.
enum SegTree {
  Empty
  Branch(Int, Range, SegTree, SegTree)
} derive(Eq, Show)

///|
/// Updates the value at a specific index in the segment tree.
///
/// # Parameters
/// - `self`: The segment tree to update.
/// - `i`: The index to update.
/// - `v`: The value to add to the current value at the index.
///
/// # Returns
/// A new segment tree with the updated value.
pub fn SegTree::update(self : SegTree, i : Index, v : Int) -> SegTree {
  match self {
    Empty => Empty
    Branch(a, rng, l, r) if rng.contains(i) =>
      Branch(a + v, rng, l.update(i, v), r.update(i, v))
    _ => self
  }
}

///|
/// Helper function to query a range in the segment tree.
///
/// # Parameters
/// - `self`: The segment tree to query.
/// - `q`: The range to query.
///
/// # Returns
/// The sum of values in the specified range.
fn rq(self : SegTree, q : Range) -> Int {
  match self {
    Empty => 0
    Branch(a, rng, l, r) =>
      if disjoint(rng, q) {
        0
      } else if subset(rng, q) {
        a
      } else {
        l.rq(q) + r.rq(q)
      }
  }
}

///|
/// Gets the value at a specific index in the segment tree.
///
/// # Parameters
/// - `self`: The segment tree to query.
/// - `i`: The index to get the value from.
///
/// # Returns
/// The value at the specified index.
pub fn SegTree::get(self : SegTree, i : Index) -> Int {
  self.rq((i, i))
}

///|
/// Sets the value at a specific index in the segment tree.
///
/// # Parameters
/// - `self`: The segment tree to update.
/// - `i`: The index to set.
/// - `v`: The new value to set at the index.
///
/// # Returns
/// A new segment tree with the updated value.
pub fn SegTree::set(self : SegTree, i : Index, v : Int) -> SegTree {
  self.update(i, v - self.get(i))
}

///|
/// Interleaves two lists together, taking elements alternately.
///
/// # Parameters
/// - `sel`: The first list.
/// - `other`: The second list.
///
/// # Returns
/// A new list with elements interleaved from both input lists.
pub fn[T] interleave(sel : List[T], other : List[T]) -> List[T] {
  match (sel, other) {
    (Nil, _) => Nil
    (Cons(x, xs), ys) => Cons(x, interleave(ys, xs))
  }
}

///|
/// Helper function to create a binary tree structure represented as a list of integers.
///
/// # Parameters
/// - `i`: The depth of the tree to generate.
///
/// # Returns
/// A list representing the binary tree structure.
fn b(i : Int) -> List[Int] {
  match i {
    0 => Cons(2, Nil)
    n =>
      Int::until(1 << n, (1 << n) + (1 << (n - 1))).map(fn { x => x * 2 })
      |> @immut/list.from_iter
      |> interleave(b(n - 1))
  }
}

///|
/// Shifts bits based on a specific condition and position.
///
/// # Parameters
/// - `n`: The position to set in the bits.
/// - `se`: The bits to shift.
///
/// # Returns
/// The shifted bits.
pub fn shift(n : Int, se : Bits) -> Bits {
  while_(even, shr, se.set(n))
}

///|
/// Converts from one binary representation to another using shifting.
///
/// # Parameters
/// - `n`: The size parameter.
/// - `se`: The bits to convert.
///
/// # Returns
/// The converted bits.
pub fn f2b(n : Int, se : Bits) -> Bits {
  shift(n + 1, se) |> dec
}

///|
/// Reverses the shift operation on bits.
///
/// # Parameters
/// - `n`: The position to clear in the bits.
/// - `se`: The bits to unshift.
///
/// # Returns
/// The unshifted bits.
pub fn unshift(n : Int, se : Bits) -> Bits {
  while_(fn { x => not(x.test_helper(n)) }, shl, se) |> Bits::clear(_, n)
}

///|
/// Converts from binary representation back to the original form.
///
/// # Parameters
/// - `n`: The size parameter.
/// - `se`: The bits to convert.
///
/// # Returns
/// The converted bits.
pub fn b2f(n : Int, se : Bits) -> Bits {
  unshift(n + 1, se.inc())
}

///|
/// Finds the active parent in a binary representation.
///
/// # Parameters
/// - `self`: The bits to analyze.
///
/// # Returns
/// The active parent bits.
pub fn active_parent_binary(self : Bits) -> Bits {
  while_(odd, shr, self.shr())
}

///|
/// Applies a function at the least significant bit position.
///
/// # Parameters
/// - `self`: The bits to operate on.
/// - `f`: The function to apply at the least significant bit.
///
/// # Returns
/// The resulting bits after applying the function.
pub fn at_lsb(self : Bits, f : (Bits) -> Bits) -> Bits {
  match self {
    Rep(O) => Rep(O)
    s =>
      match s.pat_match() {
        (bs, O) => bs.at_lsb(f) |> Bits::make(O)
        (bs, I) => Bits::make(bs, I) |> f
      }
  }
}

///|
/// Finds the previous segment in a binary representation.
///
/// # Parameters
/// - `self`: The bits to analyze.
///
/// # Returns
/// The previous segment bits.
pub fn prev_segment_binary(self : Bits) -> Bits {
  while_(even, shr, self).dec()
}

///|
test "x - lsb x" {
  let x = Bits::to_bits(26)
  inspect!(x.at_lsb(dec), content="...00011000")
}
