(* lib/formats/hex.ml *)

let configurations =
  Some [ new Common.configurable "Uppercase" `Toggle "True" None ]

class hex (direction : Common.encode_direction) =
  object
    inherit Common.operation "Hex" direction configurations

    method encode (s : string) : string =
      let to_hex_string c = Printf.sprintf "%02x" (Char.code c) in
      let hex_data =
        String.concat " "
          (List.map to_hex_string (String.to_seq s |> List.of_seq))
      in
      if (List.hd configurations)#value = "True" then
        String.uppercase_ascii hex_data
      else hex_data

    method decode (s : string) : string option =
      try
        let _ =
          String.to_seq s |> List.of_seq
          |> List.map (fun c ->
                 match c with
                 | '0' .. '9' | 'a' .. 'f' | 'A' .. 'F' | ' ' -> c
                 | _ ->
                     raise
                       (Common.Decode_error "Invalid character in hex string"))
        in
        let split_data = String.split_on_char ' ' (String.trim s) in
        let rec loop acc = function
          | [] -> acc
          | h :: t ->
              let n = int_of_string ("0x" ^ h) in
              loop (acc ^ Char.escaped (Char.chr n)) t
        in
        Some (loop "" split_data)
      with _ -> None
  end
