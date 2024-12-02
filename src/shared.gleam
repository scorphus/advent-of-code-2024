import gleam/erlang
import gleam/int
import gleam/string

pub fn read_input(lines: List(String)) -> List(String) {
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

pub fn parse_int(s: String) -> Int {
  case int.parse(s) {
    Ok(i) -> i
    Error(_) -> -1
  }
}
