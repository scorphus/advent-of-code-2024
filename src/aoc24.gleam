import argv
import gleam/io

import day01
import day02
import day03

pub fn main() {
  case argv.load().arguments {
    ["1"] -> day01.main()
    ["2"] -> day02.main()
    ["3"] -> day03.main()
    _ -> io.println("No day specified. Usage: aoc24 <day>")
  }
}
