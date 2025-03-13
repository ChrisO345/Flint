(* lib/common/common.mli *)

type configuration = [ `Toggle | `Picklist | `Text | `Number ]

type constraint_type =
  | List of string list
  | Range of (int option * int option)
  | None

class configurable :
  string ->
  configuration ->
  string ->
  constraint_type option ->
object
  val name : string
  method name : string
  val config_type : configuration
  method config_type : configuration
  val mutable value : string
  method value : string
  method set_value : string -> unit
  val constraints : constraint_type option
  method constraints : constraint_type option
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
  method configurations : configurable list
  method virtual encode : string -> string
  method virtual decode : string -> string option
  method run : string -> string
end
