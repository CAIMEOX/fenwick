///| 
/// Infinite bit representation
enum Bits {
  Rep(Bit)
  Snoc(Bits, Bit)
} derive(Eq)

///|
pub fn to_snoc(self : Bits) -> Bits {
  match self {
    Rep(a) => Snoc(Rep(a), a)
    self => self
  }
}

///|
pub fn Bits::pat_match(self : Bits) -> (Bits, Bit) {
  guard self.to_snoc() is Snoc(bs, b)
  (bs, b)
}

///|
pub fn Bits::make(self : Bits, b : Bit) -> Bits {
  match (self, b) {
    (Rep(b), b1) if b == b1 => Rep(b)
    (bs, b) => Snoc(bs, b)
  }
}

///|
fn div(n : Int, d : Int) -> Int {
  if n < 0 {
    (n - d + 1) / d
  } else {
    n / d
  }
}

///|
pub fn Bits::to_bits(n : Int) -> Bits {
  match n {
    0 => Rep(O)
    -1 => Rep(I)
    n => Bits::make(Bits::to_bits(div(n, 2)), Bit::to_enum(n % 2))
  }
}

///|
pub fn Bits::from_bits(self : Bits) -> Int {
  match self {
    Rep(O) => 0
    Rep(I) => -1
    bs => {
      let (bs, b) = bs.pat_match()
      2 * Bits::from_bits(bs) + Bit::from_enum(b)
    }
  }
}

///|
pub impl Show for Bits with to_string(self) {
  fn go {
    Rep(b) => b.to_string().repeat(3) + "..."
    s => {
      let (bs, b) = s.pat_match()
      b.to_string() + go(bs)
    }
  }

  go(self).rev()
}

///|
pub impl Show for Bits with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub fn inc(self : Bits) -> Bits {
  match self {
    Rep(I) => Rep(O)
    s =>
      match s.pat_match() {
        (bs, O) => Bits::make(bs, I)
        (bs, I) => Bits::make(bs.inc(), O)
      }
  }
}

///|
pub fn dec(self : Bits) -> Bits {
  match self {
    Rep(O) => Rep(I)
    s =>
      match s.pat_match() {
        (bs, I) => Bits::make(bs, O)
        (bs, O) => Bits::make(bs.dec(), I)
      }
  }
}

///|
pub fn lsb(self : Bits) -> Bits {
  match self {
    Rep(O) => Rep(O)
    s =>
      match s.pat_match() {
        (bs, O) => Bits::make(bs.lsb(), O)
        (_, I) => Bits::make(Rep(O), I)
      }
  }
}

///|
test "lsb" {
  inspect!(Bits::to_bits(26), content="...00011010")
  inspect!(Bits::to_bits(26).lsb(), content="...00010")
  inspect!(Bits::to_bits(24), content="...00011000")
  inspect!(Bits::to_bits(24).lsb(), content="...0001000")
}

///|
pub impl BitAnd for Bits with land(self, other) {
  match (self, other) {
    (Rep(x), Rep(y)) => Rep(x & y)
    (xs, ys) =>
      match (xs.pat_match(), ys.pat_match()) {
        ((bs, b), (bs1, b1)) => Bits::make(bs.lsb() & bs1.lsb(), b & b1)
      }
  }
}

///|
pub fn Bits::inv(self : Bits) -> Bits {
  match self {
    Rep(x) => Rep(x.not())
    s =>
      match s.pat_match() {
        (bs, b) => Bits::make(bs.inv(), b.not())
      }
  }
}

///|
pub impl Add for Bits with op_add(self, other) {
  match (self, other) {
    (xs, Rep(O)) | (Rep(O), xs) => xs
    (Rep(I), Rep(I)) => Bits::make(Rep(I), O)
    _ =>
      match (self.pat_match(), other.pat_match()) {
        ((xs, I), (ys, I)) => Bits::make((xs + ys).inc(), O)
        ((xs, x), (ys, y)) => Bits::make(xs + ys, x | y)
      }
  }
}

///|
pub impl Neg for Bits with op_neg(self) {
  self.inv().inc()
}

///|
pub fn set_to(self : Bits, idx : Int, b1 : Bit) -> Bits {
  match (idx, self.pat_match()) {
    (0, (bs, _)) => Bits::make(bs, b1)
    (k, (bs, b)) => Bits::make(bs.set_to(k - 1, b1), b)
  }
}

///|
pub fn Bits::set(self : Bits, idx : Int) -> Bits {
  self.set_to(idx, I)
}

///|
pub fn Bits::clear(self : Bits, idx : Int) -> Bits {
  self.set_to(idx, O)
}

///|
fn test_helper(self : Bits, i : Int) -> Bool {
  loop i, self.pat_match() {
    0, (_bs, b) => b == I
    k, (bs, _b) => continue k - 1, bs.pat_match()
  }
}

///|
pub fn odd(self : Bits) -> Bool {
  self.test_helper(0)
}

///|
pub fn even(self : Bits) -> Bool {
  not(self.odd())
}

///|
pub fn shr(self : Bits) -> Bits {
  self.pat_match().0
}

///|
pub fn shl(self : Bits) -> Bits {
  Bits::make(self, O)
}

///|
pub fn[A] while_(p : (A) -> Bool, f : (A) -> A, x : A) -> A {
  loop x {
    x => if p(x) { continue f(x) } else { x }
  }
}
