import gleam/int
import gleam/io
import gleam/list
import gleam/string

import shared

pub fn main() {
  let memory =
    shared.read_input([])
    |> string.join("")
  io.println("Part 1: " <> int.to_string(part_1(memory)))
  io.println("Part 2: " <> int.to_string(part_2(memory)))
}

fn part_1(memory: String) -> Int {
  memory
  |> string.split("mul(")
  |> list.fold([], fn(acc, operands) {
    string.split(operands, ")")
    |> list.fold(acc, fn(acc, operands) { [operands, ..acc] })
  })
  |> list.map(mul)
  |> list.fold(0, fn(acc, value) { acc + value })
}

fn mul(operands: String) -> Int {
  operands
  |> string.split(",")
  |> list.map(int.parse)
  |> list.fold(1, fn(acc, operand) {
    case operand {
      Ok(value) -> acc * value
      Error(_) -> 0
    }
  })
}

fn part_2(memory: String) -> Int {
  memory
  |> string.split("do()")
  |> list.fold([], fn(acc, expressions) {
    case string.split(expressions, "don't()") {
      [expressions, ..] -> [expressions, ..acc]
      _ -> acc
    }
  })
  |> string.join("")
  |> part_1()
}
