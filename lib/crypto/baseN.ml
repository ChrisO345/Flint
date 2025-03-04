(* lib/crypto/baseN.ml *)

class virtual baseN (name : string) (direction : Common.encode_direction)
  (alphabets : (string * string) list) =
  object
    inherit
      Common.operation
        name direction
        (Some
           [
             new Common.configurable
               "Alphabet" `Picklist "Standard"
               (Some (Common.List (List.map fst alphabets)));
           ])

    (* let alphabet be the second item in first tuple of alphabets *)
    val alphabet =
      match alphabets with
      | (_, second) :: _ -> second
      | _ -> failwith "No alphabet provided"
  end
