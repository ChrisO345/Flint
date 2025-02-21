(* lib/crypto/baseN.ml *)

class virtual baseN (name : string) (direction : Common.encode_direction)
  (alphabet : string) =
  object
    inherit Common.operation name direction
    val mutable alphabet = alphabet
  end
