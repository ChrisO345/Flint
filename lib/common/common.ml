(* lib/common/common.ml *)

type encode_direction = [ `Encode | `Decode ]

class virtual operation (name : string) (direction : encode_direction) =
  object (self)
    val name : string = name
    val direction : encode_direction = direction
    method virtual encode : string -> string
    method virtual decode : string -> string

    method run (input : string) : string =
      match direction with
      | `Encode -> self#encode input
      | `Decode -> self#decode input
  end
