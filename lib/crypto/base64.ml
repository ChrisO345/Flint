(* lib/crypto/base64.ml *)

type base64_alphabet = [ `Standard | `Extended ]

let determine_alphabet (alpha_type : base64_alphabet) : string =
  match alpha_type with
  | `Standard -> "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
  | `Extended -> "0123456789ABCDEFGHIJKLMNOPQRSTUV"

class base64 (direction : Common.encode_direction)
  (alphabet_type : base64_alphabet) =
  object
    inherit BaseN.baseN "Base64" direction (determine_alphabet alphabet_type)
    method encode (s : string) : string = "Base64 Encode " ^ s
    method decode (s : string) : string option = Some ("Base64 Decode " ^ s)
  end
