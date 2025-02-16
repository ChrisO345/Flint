type base32_alphabet = [ `Standard | `Extended ]

let determine_alphabet (alpha_type : base32_alphabet) : string =
  match alpha_type with
  | `Standard -> "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567="
  | `Extended -> "0123456789ABCDEFGHIJKLMNOPQRSTUV="

class base32 (direction : Utils.encode_direction)
  (alphabet_type : base32_alphabet) =
  object
    inherit
      BaseN.baseN
        (Utils.determine_name "Base32" direction)
        direction
        (determine_alphabet alphabet_type)

    method run_encode s =
      Printf.sprintf "%s (encoded): %s for %s" name s alphabet

    method run_decode s =
      Some (Printf.sprintf "%s (encoded): %s for %s" name s alphabet)
  end
