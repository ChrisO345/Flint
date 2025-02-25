(* lib/common/common.mli *)

exception Decode_error of string

type encode_direction = [ `Encode | `Decode ]

class virtual operation : string -> encode_direction -> object
  val name : string
  method name : string
  val direction : encode_direction
  method virtual encode : string -> string
  method virtual decode : string -> string option
  method run : string -> string
end
