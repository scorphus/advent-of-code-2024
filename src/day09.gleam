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
  io.println("Part 2: " <> int.to_string(part_2(disk_map)))
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
    left, l_id, _, r_id, _, _ if l_id % 2 == 0 && r_id > l_id ->
      checksum(blk, left, l_id / 2)
      + compact(l_dm, r_dm, l_id, r_id, 0, right, blk + left)
    left, _, right, r_id, _, _ -> {
      let min = int.min(left, right)
      let cs = checksum(blk, min, r_id / 2)
      cs + compact(l_dm, r_dm, l_id, r_id, left - min, right - min, blk + min)
    }
  }
}

fn part_2(disk_map: List(Int)) -> Int {
  let #(files, spaces) = split_files_and_spaces(disk_map)
  compact_files(files, spaces)
}

fn split_files_and_spaces(
  disk_map: List(Int),
) -> #(List(#(Int, Int, Int)), List(#(Int, Int))) {
  let #(files, spaces, _) =
    list.index_fold(disk_map, #([], [], 0), fn(acc, size, i) {
      let #(files, spaces, blk) = acc
      case i % 2 {
        0 -> #([#(i / 2, size, blk), ..files], spaces, blk + size)
        _ -> #(files, [#(size, blk), ..spaces], blk + size)
      }
    })
  #(files, list.reverse(spaces))
}

fn compact_files(
  files: List(#(Int, Int, Int)),
  spaces: List(#(Int, Int)),
) -> Int {
  case files {
    [file, ..files] -> {
      let #(cs, spaces) = compact_file(file, spaces, [])
      cs + compact_files(files, spaces)
    }
    [] -> 0
  }
}

fn compact_file(
  file: #(Int, Int, Int),
  spaces: List(#(Int, Int)),
  new_spaces: List(#(Int, Int)),
) -> #(Int, List(#(Int, Int))) {
  let #(fid, fsize, fblk) = file
  case spaces {
    [space, ..spaces] -> {
      let #(ssize, sblk) = space
      case sblk >= fblk, ssize < fsize {
        True, _ -> {
          let cs = checksum(fblk, fsize, fid)
          #(cs, list.flatten([list.reverse(new_spaces), [space, ..spaces]]))
        }
        _, True -> compact_file(file, spaces, [space, ..new_spaces])
        _, _ -> {
          let cs = checksum(sblk, fsize, fid)
          case ssize == fsize {
            True -> #(cs, list.flatten([list.reverse(new_spaces), spaces]))
            _ -> {
              let space = #(ssize - fsize, sblk + fsize)
              #(cs, list.flatten([list.reverse(new_spaces), [space, ..spaces]]))
            }
          }
        }
      }
    }
    [] -> #(checksum(fblk, fsize, fid), list.reverse(new_spaces))
  }
}

fn checksum(block: Int, size: Int, id: Int) -> Int {
  { block * size + size * { size + 1 } / 2 - size } * id
}
