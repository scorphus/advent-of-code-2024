import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/set
import gleam/string

import shared

pub fn main() {
  let topo_map =
    shared.read_input([])
    |> parse_topographic_map(dict.new(), 0)
  io.println("Part 1: " <> int.to_string(part_1(topo_map)))
  io.println("Part 2: " <> int.to_string(part_2(topo_map)))
}

fn parse_topographic_map(
  lines: List(String),
  topo_map: dict.Dict(#(Int, Int), Int),
  row: Int,
) -> dict.Dict(#(Int, Int), Int) {
  case lines {
    [head, ..tail] -> {
      let topo_map =
        string.to_graphemes(head)
        |> list.index_fold(topo_map, fn(acc, char, col) {
          dict.insert(acc, #(row, col), shared.parse_int(char))
        })
      parse_topographic_map(tail, topo_map, row + 1)
    }
    [] -> topo_map
  }
}

fn part_1(topo_map: dict.Dict(#(Int, Int), Int)) -> Int {
  count_summits_or_trails(topo_map, 0, 0, True)
}

fn count_summits_or_trails(
  topo_map: dict.Dict(#(Int, Int), Int),
  row: Int,
  col: Int,
  take_summits: Bool,
) -> Int {
  case dict.get(topo_map, #(row, col)) {
    Ok(0) -> {
      case take_summits {
        True ->
          find_all_summits(topo_map, 0, row, col)
          |> set.from_list()
          |> set.size()
        False ->
          find_all_summits(topo_map, 0, row, col)
          |> list.length()
      }
      + count_summits_or_trails(topo_map, row, col + 1, take_summits)
    }
    Ok(_) -> count_summits_or_trails(topo_map, row, col + 1, take_summits)
    Error(_) ->
      case row * row < dict.size(topo_map) {
        True -> count_summits_or_trails(topo_map, row + 1, 0, take_summits)
        _ -> 0
      }
  }
}

fn find_all_summits(
  topo_map: dict.Dict(#(Int, Int), Int),
  height: Int,
  row: Int,
  col: Int,
) -> List(#(Int, Int)) {
  list.flatten([
    find_summits(topo_map, height, row, col + 1),
    find_summits(topo_map, height, row + 1, col),
    find_summits(topo_map, height, row, col - 1),
    find_summits(topo_map, height, row - 1, col),
  ])
}

fn find_summits(
  topo_map: dict.Dict(#(Int, Int), Int),
  height: Int,
  row: Int,
  col: Int,
) -> List(#(Int, Int)) {
  case dict.get(topo_map, #(row, col)) {
    Ok(9) if height == 8 -> [#(row, col)]
    Ok(h) if h - height == 1 -> find_all_summits(topo_map, h, row, col)
    _ -> []
  }
}

fn part_2(topo_map: dict.Dict(#(Int, Int), Int)) -> Int {
  count_summits_or_trails(topo_map, 0, 0, False)
}
