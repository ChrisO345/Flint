(* lib/crypto/base32.ml *)

type base32_alphabet = [ `Standard | `Extended ]

let determine_alphabet (alpha_type : base32_alphabet) : string =
  match alpha_type with
  | `Standard -> "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
  | `Extended -> "0123456789ABCDEFGHIJKLMNOPQRSTUV"

class base32 (direction : Common.encode_direction)
  (alphabet_type : base32_alphabet) =
  object
    inherit BaseN.baseN "Base32" direction (determine_alphabet alphabet_type)

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
      let len_padded = 5 * ((String.length binary_data / 5) + 1) in
      let padded_binary_data =
        binary_data ^ String.make (len_padded - String.length binary_data) '0'
      in
      let chunks =
        List.init
          (String.length padded_binary_data / 5)
          (fun i -> String.sub padded_binary_data (i * 5) 5)
      in
      let b32_result =
        List.map
          (fun chunk ->
            let idx = int_of_string ("0b" ^ chunk) in
            String.make 1 alphabet.[idx])
          chunks
      in
      let b32_string = String.concat "" b32_result in
      let len_b32_padded = 8 * ((String.length b32_string / 8) + 1) in
      let padded_b32_string =
        b32_string ^ String.make (len_b32_padded - String.length b32_string) '='
      in
      padded_b32_string

    method decode (s : string) : string =
      let index_of_char c = String.index alphabet c in
      let bin_of_index i =
        let bin = Bytes.make 5 '0' in
        let rec loop n i =
          if n > 0 then (
            let bit = if n land 1 = 1 then '1' else '0' in
            Bytes.set bin (4 - i) bit;
            loop (n lsr 1) (i + 1))
        in
        loop i 0;
        Bytes.to_string bin
      in
      let stripped_data =
        String.trim (String.map (fun c -> if c = '=' then ' ' else c) s)
      in
      let binary_chunks =
        String.concat ""
          (List.map
             (fun c -> bin_of_index (index_of_char c))
             (String.to_seq stripped_data |> List.of_seq))
      in
      let binary_data =
        List.init
          (String.length binary_chunks / 8)
          (fun i -> String.sub binary_chunks (i * 8) 8)
      in
      let result =
        List.map
          (fun chunk ->
            let idx = int_of_string ("0b" ^ chunk) in
            Char.chr idx)
          binary_data
      in
      String.concat "" (List.map (String.make 1) result)
  end
