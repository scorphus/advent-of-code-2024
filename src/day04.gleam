import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/string

import shared

pub fn main() {
  let word_search =
    shared.read_input([])
    |> build_word_search()
  io.println("Part 1: " <> int.to_string(part_1(word_search)))
  io.println("Part 2: " <> int.to_string(part_2(word_search)))
}

fn build_word_search(lines: List(String)) -> dict.Dict(#(Int, Int), String) {
  lines
  |> list.index_fold(dict.new(), fn(acc, line, i) {
    string.to_graphemes(line)
    |> list.index_fold(acc, fn(acc, char, j) { dict.insert(acc, #(i, j), char) })
  })
}

fn part_1(word_search: dict.Dict(#(Int, Int), String)) -> Int {
  dict.fold(word_search, 0, fn(acc, pos, char) {
    case char {
      "X" -> acc + count_xmas(word_search, pos)
      _ -> acc
    }
  })
}

fn count_xmas(
  word_search: dict.Dict(#(Int, Int), String),
  pos: #(Int, Int),
) -> Int {
  let #(i, j) = pos
  let mas = ["M", "A", "S"]
  [
    [#(i - 1, j), #(i - 2, j), #(i - 3, j)],
    [#(i, j + 1), #(i, j + 2), #(i, j + 3)],
    [#(i + 1, j), #(i + 2, j), #(i + 3, j)],
    [#(i, j - 1), #(i, j - 2), #(i, j - 3)],
    [#(i - 1, j + 1), #(i - 2, j + 2), #(i - 3, j + 3)],
    [#(i + 1, j + 1), #(i + 2, j + 2), #(i + 3, j + 3)],
    [#(i + 1, j - 1), #(i + 2, j - 2), #(i + 3, j - 3)],
    [#(i - 1, j - 1), #(i - 2, j - 2), #(i - 3, j - 3)],
  ]
  |> list.fold(0, fn(acc, positions) {
    acc
    + list.fold(list.zip(positions, mas), 1, fn(acc, pos_letter) {
      let #(pos, letter) = pos_letter
      case dict.get(word_search, pos) {
        Ok(v) if v == letter -> acc * 1
        _ -> acc * 0
      }
    })
  })
}

fn part_2(word_search: dict.Dict(#(Int, Int), String)) -> Int {
  dict.fold(word_search, 0, fn(acc, pos, char) {
    case char {
      "A" -> acc + count_x_mas(word_search, pos)
      _ -> acc
    }
  })
}

fn count_x_mas(
  word_search: dict.Dict(#(Int, Int), String),
  pos: #(Int, Int),
) -> Int {
  let #(i, j) = pos
  let ne = dict.get(word_search, #(i - 1, j + 1))
  let se = dict.get(word_search, #(i + 1, j + 1))
  let sw = dict.get(word_search, #(i + 1, j - 1))
  let nw = dict.get(word_search, #(i - 1, j - 1))
  case ne, se, sw, nw {
    Ok("M"), Ok("M"), Ok("S"), Ok("S") -> 1
    Ok("S"), Ok("S"), Ok("M"), Ok("M") -> 1
    Ok("M"), Ok("S"), Ok("S"), Ok("M") -> 1
    Ok("S"), Ok("M"), Ok("M"), Ok("S") -> 1
    _, _, _, _ -> 0
  }
}
