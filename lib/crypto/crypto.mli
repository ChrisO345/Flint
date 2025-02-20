module Base32 : sig
  type base32_alphabet = [ `Standard | `Extended ]

  class base32 : Common.encode_direction -> base32_alphabet -> object
    method encode : string -> string
    method decode : string -> string option
    method run : string -> string
  end
end
