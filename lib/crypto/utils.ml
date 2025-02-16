type encode_direction = [ `To | `From ]

let determine_name (name : string) (direction : encode_direction) : string =
  (match direction with `To -> "To" | `From -> "From") ^ " " ^ name
