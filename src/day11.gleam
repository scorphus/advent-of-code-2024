import gleam/dict
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string

import shared

pub fn main() {
  let stone_counts =
    shared.read_line()
    |> string.split(" ")
    |> list.map(shared.parse_int)
    |> list.fold(dict.new(), fn(acc, stone) { increment(acc, stone, 1) })
  io.println("Part 1: " <> int.to_string(part_1(stone_counts, 25)))
  io.println("Part 2: " <> int.to_string(part_1(stone_counts, 75)))
}

fn part_1(stone_counts: dict.Dict(Int, Int), blinks: Int) -> Int {
  list.range(1, blinks)
  |> list.fold(stone_counts, fn(stone_counts, _) { blink(stone_counts) })
  |> dict.values()
  |> int.sum()
}

fn blink(stone_counts: dict.Dict(Int, Int)) -> dict.Dict(Int, Int) {
  dict.fold(stone_counts, dict.new(), fn(stone_counts, stone, count) {
    change(stone)
    |> list.fold(stone_counts, fn(stone_counts, stone) {
      increment(stone_counts, stone, count)
    })
  })
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

fn increment(
  stone_counts: dict.Dict(Int, Int),
  stone: Int,
  incr: Int,
) -> dict.Dict(Int, Int) {
  dict.upsert(stone_counts, stone, fn(count) {
    case count {
      Some(count) -> count + incr
      None -> incr
    }
  })
}
