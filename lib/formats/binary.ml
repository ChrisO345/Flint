(* lib/formats/binary.ml *)

class binary (direction : Common.encode_direction) =
  object
    inherit Common.operation "Binary" direction

    method encode (s : string) : string =
      let to_binary_string c =
        let bin = Bytes.make 8 '0' in
        let rec loop n i =
          if n > 0 then (
            let bit = if n land 1 = 1 then '1' else '0' in
            Bytes.set bin (7 - i) bit;
            loop (n lsr 1) (i + 1))
        in
        loop (Char.code c) 0;
        Bytes.to_string bin
      in
      let binary_data =
        String.concat " "
          (List.map to_binary_string (String.to_seq s |> List.of_seq))
      in
      binary_data

    method decode (s : string) : string option =
      try
        let _ =
          String.to_seq s |> List.of_seq
          |> List.map (fun c ->
                 match c with
                 | '0' | '1' | ' ' -> c
                 | _ ->
                     raise
                       (Common.Decode_error "Invalid character in binary string"))
        in
        let split_data = String.split_on_char ' ' (String.trim s) in
        let rec loop acc = function
          | [] -> acc
          | h :: t ->
              let n = int_of_string ("0b" ^ h) in
              loop (acc ^ Char.escaped (Char.chr n)) t
        in
        Some (loop "" split_data)
      with _ -> None
  end
