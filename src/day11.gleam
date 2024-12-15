import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

import shared

pub fn main() {
  let stones =
    shared.read_line()
    |> string.split(" ")
    |> list.map(shared.parse_int)
  io.println("Part 1: " <> int.to_string(part_1(stones)))
}

fn part_1(stones: List(Int)) -> Int {
  list.range(1, 25)
  |> list.fold(stones, fn(acc, _) { blink(acc) })
  |> list.length()
}

fn blink(stones: List(Int)) -> List(Int) {
  list.map(stones, change)
  |> list.flatten()
}

fn change(stone: Int) -> List(Int) {
  case stone {
    0 -> [1]
    _ -> {
      case float.truncate(shared.log10(int.to_float(stone))) + 1 {
        n if n % 2 == 0 -> {
          let quot =
            int.to_float(n / 2)
            |> shared.pow(10.0, _)
            |> float.truncate()
          let left =
            int.divide(stone, quot)
            |> result.unwrap(0)
          [left, stone - left * quot]
        }
        _ -> [stone * 2024]
      }
    }
  }
}
