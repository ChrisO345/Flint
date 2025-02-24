(* lib/crypto/crypto.mli *)

module Base32 : sig
  type base32_alphabet = [ `Standard | `Extended ]

  class base32 : Common.encode_direction -> base32_alphabet -> object
    method name : string
    method encode : string -> string
    method decode : string -> string option
    method run : string -> string
  end
end

module Base64 : sig
  type base64_alphabet = [ `RFC4648 ]

  class base64 : Common.encode_direction -> base64_alphabet -> object
    method name : string
    method encode : string -> string
    method decode : string -> string option
    method run : string -> string
  end
end
