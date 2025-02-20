type base32_alphabet = [ `Standard | `Extended ]

let determine_alphabet (alpha_type : base32_alphabet) : string =
  match alpha_type with
  | `Standard -> "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567="
  | `Extended -> "0123456789ABCDEFGHIJKLMNOPQRSTUV="

class base32 (direction : Common.encode_direction)
  (alphabet_type : base32_alphabet) =
  object
    inherit BaseN.baseN "Base32" direction (determine_alphabet alphabet_type)
    method encode s = Printf.sprintf "%s (encoded): %s for %s" name s alphabet

    method decode s =
      Some (Printf.sprintf "%s (encoded): %s for %s" name s alphabet)
  end
