(* lib/api/api.ml *)

open Crypto

(* TODO: hashmap this collection based on name *)
let items =
  [
    new Base32.base32 `Encode `Standard;
    new Base32.base32 `Decode `Standard;
    new Base64.base64 `Encode `Standard;
    new Base64.base64 `Decode `Standard;
  ]

let queue =
  ref
    (*  [ new Base32.base32 `Encode `Standard; new Base32.base32 `Decode `Standard ] *)
    [ new Base32.base32 `Encode `Standard ]

let run_encode_queue contents =
  let rec run_queue queue contents =
    match queue with
    | [] -> contents
    | encoder :: rest ->
        let encoded_string = encoder#run contents in
        run_queue rest encoded_string
  in
  run_queue !queue contents

let wrap_filterable_div item =
  "<div class=\"filterable\">" ^ item#name ^ "</div>"

let get_filterable_items () =
  let div_items = List.map wrap_filterable_div items in
  String.concat "" div_items

let get_queue_item_names () =
  let queue_names = List.map (fun item -> item#name) !queue in
  String.concat "\n" queue_names

let methods = [ `GET; `ADD; `REM; `CLS; `ERR ]

let parse_json (req : string) : string =
  (* This is a basic json parser assuming that there are no commas apart from the value separators and known value headers *)
  let json = String.sub req 1 (String.length req - 2) in
  let json_list = String.split_on_char ',' json in
  Printf.printf "json_list: %s\n" (String.concat "\n" json_list);
  (* Method should always be the first element *)
  let method_elem = List.nth json_list 0 in
  let method_str = String.sub method_elem 10 (String.length method_elem - 11) in
  let meth =
    match method_str with
    | "GET" -> `GET
    | "ADD" -> `ADD
    | "REM" -> `REM
    | "CLS" -> `CLS
    | _ -> `ERR
  in
  if meth = `ERR then "ERROR with method"
  else if meth = `CLS then (
    queue := [];
    "Queue cleared")
  else if meth <> `GET then
    let name_elem = List.nth json_list 1 in
    let name = String.sub name_elem 8 (String.length name_elem - 9) in
    match meth with
    | `ADD -> (
        match List.find_opt (fun item -> item#name = name) items with
        | Some encoder ->
            queue := !queue @ [ encoder ];
            "Added " ^ name ^ " to the queue. Current queue: "
            ^ String.concat ", " (List.map (fun item -> item#name) !queue)
        | None -> "ERROR: Encoder not found")
    | `REM ->
        queue := List.filter (fun item -> item#name <> name) !queue;
        "Removed " ^ name ^ " from the queue. Current queue: "
        ^ String.concat ", " (List.map (fun item -> item#name) !queue)
    | _ -> "ERROR with queue manipulation"
  else get_queue_item_names ()

let handle_queue_request (req : string) = parse_json req
