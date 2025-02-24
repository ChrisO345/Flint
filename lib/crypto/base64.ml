(* lib/crypto/base64.ml *)

type base64_alphabet = [ `RFC4648 ]

let determine_alphabet (alpha_type : base64_alphabet) : string =
  match alpha_type with
  | `RFC4648 ->
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

class base64 (direction : Common.encode_direction)
  (alphabet_type : base64_alphabet) =
  object
    inherit BaseN.baseN "Base64" direction (determine_alphabet alphabet_type)

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
        String.concat ""
          (List.map to_binary_string (String.to_seq s |> List.of_seq))
      in
      let len_padded = 6 * ((String.length binary_data / 6) + 1) in
      let padded_binary_data =
        binary_data ^ String.make (len_padded - String.length binary_data) '0'
      in
      let chunks =
        List.init
          (String.length padded_binary_data / 6)
          (fun i -> String.sub padded_binary_data (i * 6) 6)
      in
      let b64_result =
        List.map
          (fun chunk ->
            let idx = int_of_string ("0b" ^ chunk) in
            alphabet.[idx])
          chunks
      in
      let b64_string = String.of_seq (List.to_seq b64_result) in
      let padded_b64_string =
        b64_string ^ String.make (4 - (String.length b64_string mod 4)) '='
      in
      padded_b64_string

    method decode (s : string) : string option =
      try
        let trimmed = String.sub s 0 (String.index s '=') in
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
        let len_padded = 8 * ((String.length binary_string / 8) + 1) in
        let padded_binary_string =
          binary_string
          ^ String.make (len_padded - String.length binary_string) '0'
        in
        let chunks =
          List.init
            (String.length padded_binary_string / 8)
            (fun i -> String.sub padded_binary_string (i * 8) 8)
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
