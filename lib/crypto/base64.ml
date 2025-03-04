(* lib/crypto/base64.ml *)

type base64_alphabet = [ `RFC4648 ]

let custom_alphabet : (string * string) list =
  [
    ( "RFC4648",
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" );
  ]

class base64 (direction : Common.encode_direction) =
  object
    inherit BaseN.baseN "Base64" direction custom_alphabet

    method encode (s : string) : string =
      let to_binary_string c =
        let bin = Bytes.make 8 '0' in
        let rec loop n i =
          if i >= 0 then (
            Bytes.set bin i (if n land 1 = 1 then '1' else '0');
            loop (n lsr 1) (i - 1))
        in
        loop (Char.code c) 7;
        Bytes.to_string bin
      in
      let binary_data =
        String.concat ""
          (List.map to_binary_string (String.to_seq s |> List.of_seq))
      in
      let valid_length = String.length binary_data / 6 * 6 in
      let valid_binary_data = String.sub binary_data 0 valid_length in
      let chunks =
        List.init
          (String.length valid_binary_data / 6)
          (fun i -> String.sub valid_binary_data (i * 6) 6)
      in
      let b64_result =
        List.map
          (fun chunk ->
            let idx = int_of_string ("0b" ^ chunk) in
            alphabet.[idx])
          chunks
      in
      let b64_string = String.of_seq (List.to_seq b64_result) in
      let padding_needed =
        match String.length s mod 3 with 1 -> "==" | 2 -> "=" | _ -> ""
      in
      b64_string ^ padding_needed

    method decode (s : string) : string option =
      try
        let trimmed =
          String.trim (String.map (fun c -> if c = '=' then ' ' else c) s)
          |> String.trim
        in
        let split_string = String.to_seq trimmed |> List.of_seq in
        let binary_data =
          List.map
            (fun c ->
              let idx = String.index alphabet c in
              let bin = Bytes.make 6 '0' in
              let rec loop n i =
                if n > 0 then (
                  let bit = if n land 1 = 1 then '1' else '0' in
                  Bytes.set bin (5 - i) bit;
                  loop (n lsr 1) (i + 1))
              in
              loop idx 0;
              Bytes.to_string bin)
            split_string
        in
        let binary_string = String.concat "" binary_data in
        let valid_length = String.length binary_string / 8 * 8 in
        let valid_binary_string = String.sub binary_string 0 valid_length in
        let chunks =
          List.init
            (String.length valid_binary_string / 8)
            (fun i -> String.sub valid_binary_string (i * 8) 8)
        in
        let result =
          List.map
            (fun chunk ->
              let idx = int_of_string ("0b" ^ chunk) in
              Char.chr idx)
            chunks
        in
        Some (String.of_seq (List.to_seq result))
      with _ -> None
  end
