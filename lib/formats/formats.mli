module Binary : sig
  class binary : Common.encode_direction -> object
    method name : string
    method encode : string -> string
    method decode : string -> string option
    method run : string -> string
  end
end
