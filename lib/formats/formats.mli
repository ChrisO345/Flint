(* lib/formats/formats.mli *)

module Binary : sig
  class binary : Common.encode_direction -> object
    method name : string
    method configurations : Common.configurable list
    method encode : string -> string
    method decode : string -> string option
    method run : string -> string
  end
end

module Hex : sig
  class hex : Common.encode_direction -> object
    method name : string
    method configurations : Common.configurable list
    method encode : string -> string
    method decode : string -> string option
    method run : string -> string
  end
end

module Octal : sig
  class octal : Common.encode_direction -> object
    method name : string
    method configurations : Common.configurable list
    method encode : string -> string
    method decode : string -> string option
    method run : string -> string
  end
end
