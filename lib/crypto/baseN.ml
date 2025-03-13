(* lib/crypto/baseN.ml *)

class virtual baseN (name : string) (direction : Common.encode_direction)
  (default : string) (alphabets : (string * string) list) =
  object
    inherit
      Common.operation
        name direction
        (Some
           [
             new Common.configurable
               "Alphabet" `Picklist default
               (Some (Common.List (List.map fst alphabets)));
           ])
  end
