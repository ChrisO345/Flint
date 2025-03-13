(* lib/api/collection.ml *)

open Crypto
open Formats

let keys = ref []
let items = Hashtbl.create 10

let add_item name factory =
  Hashtbl.add items name factory;
  keys := !keys @ [ name ]

let () =
  List.iter
    (fun (name, factory) -> add_item name factory)
    [
      ("Base32 (Encode)", fun () -> new Base32.base32 `Encode);
      ("Base32 (Decode)", fun () -> new Base32.base32 `Decode);
      ("Base64 (Encode)", fun () -> new Base64.base64 `Encode);
      ("Base64 (Decode)", fun () -> new Base64.base64 `Decode);
      ("Binary (Encode)", fun () -> new Binary.binary `Encode);
      ("Binary (Decode)", fun () -> new Binary.binary `Decode);
      ("Hex (Encode)", fun () -> new Hex.hex `Encode);
      ("Hex (Decode)", fun () -> new Hex.hex `Decode);
      ("Octal (Encode)", fun () -> new Octal.octal `Encode);
      ("Octal (Decode)", fun () -> new Octal.octal `Decode);
    ]
