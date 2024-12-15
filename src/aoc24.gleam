import argv
import gleam/io

import day01
import day02
import day03
import day04
import day05
import day06
import day07
import day08
import day09
import day10
import day11

pub fn main() {
  case argv.load().arguments {
    ["1"] -> day01.main()
    ["2"] -> day02.main()
    ["3"] -> day03.main()
    ["4"] -> day04.main()
    ["5"] -> day05.main()
    ["6"] -> day06.main()
    ["7"] -> day07.main()
    ["8"] -> day08.main()
    ["9"] -> day09.main()
    ["10"] -> day10.main()
    ["11"] -> day11.main()
    _ -> io.println("No valid day specified. Usage: aoc24 <day>")
  }
}
