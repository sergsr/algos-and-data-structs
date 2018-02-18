extern crate euler;

use euler::io;
use euler::raw_inputs;
use euler::solutions;

fn main() {
  println!("Solution to 8: {}",
    solutions::largest_product_in_a_series(
      13, io::digits_from_str(raw_inputs::INPUT_8)).unwrap());
}
