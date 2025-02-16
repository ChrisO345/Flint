module Base32 : sig
  type base32_alphabet = [ `Standard | `Extended ]

  class base32 : Utils.encode_direction -> base32_alphabet -> object
    method run_encode : string -> string
    method run_decode : string -> string option
    method encoder : string -> string
  end
end
