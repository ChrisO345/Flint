class virtual baseN (name : string) (direction : Utils.encode_direction)
  (alphabet : string) =
  object (self)
    val name = name
    val direction = direction
    val mutable alphabet = alphabet

    (* Encoders and Decoders *)
    method virtual run_encode : string -> string
    method virtual run_decode : string -> string option

    method encoder (phrase : string) : string =
      match direction with
      | `To -> self#run_encode phrase
      | `From -> self#run_decode phrase |> Option.get
  end
