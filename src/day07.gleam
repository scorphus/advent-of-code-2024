import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/string

import shared

pub fn main() {
  let calib_equations =
    shared.read_input([])
    |> read_calib_equations([])
  io.println("Part 1: " <> int.to_string(both_parts(calib_equations, False)))
  io.println("Part 2: " <> int.to_string(both_parts(calib_equations, True)))
}

fn read_calib_equations(
  lines: List(String),
  calib_equations: List(#(Int, List(Int))),
) -> List(#(Int, List(Int))) {
  case lines {
    [head, ..tail] -> {
      head
      |> read_calib_equation(calib_equations)
      |> read_calib_equations(tail, _)
    }
    [] -> calib_equations
  }
}

fn read_calib_equation(
  line: String,
  calib_equations: List(#(Int, List(Int))),
) -> List(#(Int, List(Int))) {
  case string.split(line, ": ") {
    [test_val, numbers, ..] -> {
      let test_val = shared.parse_int(test_val)
      let numbers = list.map(string.split(numbers, " "), shared.parse_int)
      [#(test_val, numbers), ..calib_equations]
    }
    _ -> panic as "Invalid calibration equation"
  }
}

fn both_parts(calib_equations: List(#(Int, List(Int))), is_concat: Bool) -> Int {
  list.fold(calib_equations, 0, fn(acc, calib_equation) {
    let #(test_val, numbers) = calib_equation
    case check(test_val, numbers, is_concat) {
      True -> acc + test_val
      False -> acc
    }
  })
}

fn check(test_val: Int, numbers: List(Int), is_concat: Bool) -> Bool {
  case numbers {
    [n] -> n == test_val
    [m, n, ..numbers] -> {
      check(test_val, [m + n, ..numbers], is_concat)
      || check(test_val, [m * n, ..numbers], is_concat)
      || { is_concat && check(test_val, [concat(m, n), ..numbers], is_concat) }
    }
    [] -> False
  }
}

fn concat(a: Int, b: Int) -> Int {
  let exp = float.floor(float.add(shared.log10(int.to_float(b)), 1.0))
  a * float.truncate(shared.pow(10.0, exp)) + b
}
