import gleam/int
import gleam/io
import gleam/list
import gleam/string

import shared

pub fn main() {
  let disk_map =
    shared.read_line()
    |> string.trim()
    |> string.to_graphemes()
    |> list.map(shared.parse_int)
  io.println("Part 1: " <> int.to_string(part_1(disk_map)))
}

fn part_1(disk_map: List(Int)) -> Int {
  compact(disk_map, list.reverse(disk_map), -1, list.length(disk_map), 0, 0, 0)
}

fn compact(
  l_dm: List(Int),
  r_dm: List(Int),
  l_id: Int,
  r_id: Int,
  left: Int,
  right: Int,
  blk: Int,
) -> Int {
  case left, l_id, right, r_id, l_dm, r_dm {
    _, l_id, _, r_id, _, _ if r_id < l_id -> 0
    _, _, right, r_id, _, [r_head, ..r_tail] if right == 0 || r_id % 2 == 1 ->
      compact(l_dm, r_tail, l_id, r_id - 1, left, r_head, blk)
    0, _, _, _, [l_head, ..r_tail], _ ->
      compact(r_tail, r_dm, l_id + 1, r_id, l_head, right, blk)
    left, l_id, _, r_id, _, _ if l_id % 2 == 0 && r_id > l_id -> {
      let factor = blk * left + left * { left + 1 } / 2 - left
      let checksum = factor * l_id / 2
      checksum + compact(l_dm, r_dm, l_id, r_id, 0, right, blk + left)
    }
    left, _, right, r_id, _, _ -> {
      let min = int.min(left, right)
      let factor = blk * min + min * { min + 1 } / 2 - min
      let checksum = factor * r_id / 2
      checksum
      + compact(l_dm, r_dm, l_id, r_id, left - min, right - min, blk + min)
    }
  }
}
