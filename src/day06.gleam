import gleam/int
import gleam/io
import gleam/list
import gleam/set
import gleam/string

import shared

pub fn main() {
  let #(lab_map, row, r, c) =
    shared.read_input([])
    |> parse_input(set.new(), 0, -1, -1)
  io.println("Part 1: " <> int.to_string(part_1(lab_map, row, r, c)))
  io.println("Part 2: " <> int.to_string(part_2(lab_map, row, r, c)))
}

fn parse_input(
  lines: List(String),
  lab_map: set.Set(#(Int, Int)),
  row: Int,
  r: Int,
  c: Int,
) -> #(set.Set(#(Int, Int)), Int, Int, Int) {
  case lines {
    [head, ..tail] -> {
      let #(lab_map, row, r, c) =
        string.to_graphemes(head)
        |> list.index_fold(#(lab_map, row, r, c), fn(acc, char, col) {
          case char {
            "#" -> #(set.insert(acc.0, #(acc.1, col)), acc.1, acc.2, acc.3)
            "^" -> #(acc.0, acc.1, acc.1, col)
            _ -> acc
          }
        })
      parse_input(tail, lab_map, row + 1, r, c)
    }
    [] -> #(lab_map, row, r, c)
  }
}

fn part_1(lab_map: set.Set(#(Int, Int)), row: Int, r: Int, c: Int) -> Int {
  set.from_list([#(r, c)])
  |> exit_the_lab(lab_map, row, r, c, -1, 0, _, set.new())
}

fn exit_the_lab(
  lab_map: set.Set(#(Int, Int)),
  row: Int,
  r: Int,
  c: Int,
  dr: Int,
  dc: Int,
  visited: set.Set(#(Int, Int)),
  hits: set.Set(#(Int, Int, Int, Int)),
) -> Int {
  let #(nr, nc) = #(r + dr, c + dc)
  case set.contains(lab_map, #(nr, nc)) {
    True -> {
      case set.contains(hits, #(r, c, dr, dc)) {
        True -> -1
        False -> {
          set.insert(hits, #(r, c, dr, dc))
          |> exit_the_lab(lab_map, row, r, c, dc, -dr, visited, _)
        }
      }
    }
    False -> {
      case nr >= 0 && nr < row && nc >= 0 && nc < row {
        True -> {
          set.insert(visited, #(nr, nc))
          |> exit_the_lab(lab_map, row, nr, nc, dr, dc, _, hits)
        }
        False -> set.size(visited)
      }
    }
  }
}

fn part_2(lab_map: set.Set(#(Int, Int)), row: Int, r: Int, c: Int) -> Int {
  list.range(0, row - 1)
  |> list.fold(0, fn(acc, nr) {
    list.range(0, row - 1)
    |> list.fold(acc, fn(acc, nc) {
      let visited = set.from_list([#(r, c)])
      let lab_map = set.insert(lab_map, #(nr, nc))
      case exit_the_lab(lab_map, row, r, c, -1, 0, visited, set.new()) {
        -1 -> acc + 1
        _ -> acc
      }
    })
  })
}
