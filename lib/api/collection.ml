(* lib/api/collection.ml *)

open Crypto
open Formats

(*
TODO: hashmap this collection based on name??
*)
let items =
  [
    (* Base Encryptions *)
    new Base32.base32 `Encode;
    new Base32.base32 `Decode;
    new Base64.base64 `Encode;
    new Base64.base64 `Decode;
    (* Formats *)
    new Binary.binary `Encode;
    new Binary.binary `Decode;
    new Hex.hex `Encode;
    new Hex.hex `Decode;
    new Octal.octal `Encode;
    new Octal.octal `Decode;
  ]
