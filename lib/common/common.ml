(* lib/common/common.ml *)

type configuration = [ `Toggle | `Picklist | `Text | `Number ]

type constraint_type =
  | List of string list
  | Range of (int option * int option)

class configurable (name : string) (config_type : configuration)
  (default : string) (constraints : constraint_type option) =
  object
    val name : string = name
    val config_type : configuration = config_type
    val mutable value : string = default
    val constraints : constraint_type option = constraints
  end

exception Decode_error of string

type encode_direction = [ `Encode | `Decode ]

class virtual operation (name : string) (direction : encode_direction)
  (configurations : configurable list option) =
  object (self)
    val name : string = name

    method name : string =
      match direction with
      | `Encode -> name ^ " (encode)"
      | `Decode -> name ^ " (decode)"

    val direction : encode_direction = direction

    val configurations : configurable list =
      match configurations with Some cfgs -> cfgs | None -> []

    method virtual encode : string -> string
    method virtual decode : string -> string option

    method run (input : string) : string =
      match direction with
      | `Encode -> self#encode input
      | `Decode -> (
          match self#decode input with
          | Some output -> output
          | None -> "Error with decoding " ^ name)
  end
