(* lib/api/api.ml *)

open Crypto

let queue =
  (*  [ new Base32.base32 `Encode `Standard; new Base32.base32 `Decode `Standard ] *)
  [ new Base32.base32 `Decode `Standard ]

let run_encode_queue =
  let rec run_queue queue contents =
    match queue with
    | [] -> contents
    | encoder :: rest ->
        let encoded_string = encoder#run contents in
        run_queue rest encoded_string
  in
  run_queue queue

let wrap_filterable_div item = "<div class=\"filterable\">" ^ item ^ "</div>"

let get_filterable_items () =
  let items = [ "Hello"; "World"; "Goodbye" ] in
  let div_items = List.map wrap_filterable_div items in
  String.concat "" div_items
