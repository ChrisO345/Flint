(* lib/api/collection.ml *)

open Crypto

(*
TODO: hashmap this collection based on name??
*)
let items =
  [
    new Base32.base32 `Encode `Standard;
    new Base32.base32 `Decode `Standard;
    new Base64.base64 `Encode `RFC4648;
    new Base64.base64 `Decode `RFC4648;
  ]
