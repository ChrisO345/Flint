(* lib/formats/octal.ml *)

class octal (direction : Common.encode_direction) =
  object
    inherit Common.operation "Octal" direction

    method encode (s : string) : string =
      let to_octal_string c = Printf.sprintf "%03o" (Char.code c) in
      let octal_data =
        String.concat " "
          (List.map to_octal_string (String.to_seq s |> List.of_seq))
      in
      octal_data

    method decode (s : string) : string option =
      try
        let _ =
          String.to_seq s |> List.of_seq
          |> List.map (fun c ->
                 match c with
                 | '0' .. '7' | ' ' -> c
                 | _ ->
                     raise
                       (Common.Decode_error "Invalid character in octal string"))
        in
        let split_data = String.split_on_char ' ' (String.trim s) in
        let rec loop acc = function
          | [] -> acc
          | h :: t ->
              let n = int_of_string ("0o" ^ h) in
              loop (acc ^ Char.escaped (Char.chr n)) t
        in
        Some (loop "" split_data)
      with _ -> None
  end
