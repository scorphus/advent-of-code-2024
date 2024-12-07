import argv
import gleam/io

import day01
import day02
import day03
import day04
import day05
import day06

pub fn main() {
  case argv.load().arguments {
    ["1"] -> day01.main()
    ["2"] -> day02.main()
    ["3"] -> day03.main()
    ["4"] -> day04.main()
    ["5"] -> day05.main()
    ["6"] -> day06.main()
    _ -> io.println("No valid day specified. Usage: aoc24 <day>")
  }
}
