import gleam/int
import gleam/erlang
import gleam/list
import gleam/io
import gleam/string

pub fn main() {
  let lines = read_input([])
  let #(list_one, list_two) = extract_lists(lines)
  let list_one = list.sort(list_one, by: int.compare)
  let list_two = list.sort(list_two, by: int.compare)
  io.println("Part 1: " <> int.to_string(part_1(list_one, list_two)))
  io.println("Part 2: " <> int.to_string(part_2(list_one, list_two)))
}

fn read_input(lines: List(String)) -> List(String) {
  let line = erlang.get_line("")
  case line {
    Ok(line) -> {
      let line = string.trim(line)
      [line, ..lines]
        |> read_input()
    }
    Error(_) -> lines
  }
}

fn extract_lists(lines: List(String)) -> #(List(Int), List(Int)) {
  case lines {
    [head, ..tail] -> {
      let head = head
        |> string.split(" ")
        |> list.filter(fn(s) { s != "" })
        |> list.map(parse_int)
      let #(a, b) = case head {
        [a, b] -> #(a, b)
        _ -> #(-1, -1)
      }
      let #(list_one, list_two) = extract_lists(tail)
      #([a, ..list_one], [b, ..list_two])
    }
    [] -> #([], [])
  }
}

fn parse_int(s: String) -> Int {
  case int.parse(s) {
    Ok(i) -> i
    Error(_) -> -1
  }
}

fn part_1(list_one: List(Int), list_two: List(Int)) -> Int {
  list.zip(list_one, list_two)
    |> list.map(fn(x) { int.absolute_value(x.0 - x.1) })
    |> list.fold(0, fn(acc, x) { acc + x })
}

fn part_2(list_one: List(Int), list_two: List(Int)) -> Int {
  list.fold(list_one, [], fn(acc_x, x) {
    [x * list.fold_until(list_two, 0, fn(acc_y, y) {
      case y {
        n if n < x -> list.Continue(acc_y)
        n if n == x -> list.Continue(acc_y + 1)
        _ -> list.Stop(acc_y)
      }
    }), ..acc_x]
  })
    |> list.fold(0, fn(acc, x) { acc + x })
}
