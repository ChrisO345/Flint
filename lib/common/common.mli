(* lib/common/common.mli *)

type configuration = [ `Toggle | `Picklist | `Text | `Number ]

type constraint_type =
  | List of string list
  | Range of (int option * int option)

class configurable :
  string ->
  configuration ->
  string ->
  constraint_type option ->
object
  val name : string
  val mutable value : string
  val constraints : constraint_type option
end

exception Decode_error of string

type encode_direction = [ `Encode | `Decode ]

class virtual operation :
  string ->
  encode_direction ->
  configurable list option ->
object
  val name : string
  method name : string
  val direction : encode_direction
  val configurations : configurable list
  method virtual encode : string -> string
  method virtual decode : string -> string option
  method run : string -> string
end
