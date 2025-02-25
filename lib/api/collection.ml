(* lib/api/collection.ml *)

open Crypto
open Formats

(*
TODO: hashmap this collection based on name??
*)
let items =
  [
    new Base32.base32 `Encode `Standard;
    new Base32.base32 `Decode `Standard;
    new Base64.base64 `Encode `RFC4648;
    new Base64.base64 `Decode `RFC4648;
    new Binary.binary `Encode;
    new Binary.binary `Decode;
  ]
