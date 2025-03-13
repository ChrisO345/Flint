(* lib/api/api.ml *)

let queue = ref []

let run_encode_queue contents =
  let rec run_queue queue contents =
    match queue with
    | [] -> contents
    | encoder :: rest ->
        let encoded_string = encoder#run contents in
        run_queue rest encoded_string
  in
  run_queue !queue contents

let wrap_filterable_div name = "<div class=\"filterable\">" ^ name ^ "</div>"

let get_filterable_items () =
  let div_items = List.map wrap_filterable_div !Collection.keys in
  String.concat "" div_items

let get_configuration_component component =
  let cfg_name = component#name in
  let result =
    match component#config_type with
    | `Toggle ->
        let check = if component#value = "True" then "checked" else "" in
        cfg_name ^ "<input type=\"checkbox\" class=\"configuration-element\" "
        ^ check ^ "/>"
    | `Picklist -> cfg_name ^ " Picklist"
    | `Text -> cfg_name ^ " Text"
    | `Number -> cfg_name ^ " Number"
  in
  result

let get_queue_item_names () =
  let divs = ref "" in
  List.iteri
    (fun index item ->
      let line = item#name in
      divs := !divs ^ "<div class=\"queue-item\">" ^ line;
      (divs :=
         match item#configurations with
         | [] -> !divs
         | cfgs ->
             !divs ^ "<br><p> "
             ^ String.concat ", "
                 (List.map (fun cfg -> get_configuration_component cfg) cfgs)
             ^ "</p>");

      divs := !divs ^ "<div class=\"queue-buttons\">";
      if index <> 0 then
        divs :=
          !divs ^ "<button onclick=\"modifyServerQueue('" ^ line ^ "', "
          ^ string_of_int index ^ ", 'INC')\">^</button>";
      if index <> List.length !queue - 1 then
        divs :=
          !divs ^ "<button onclick=\"modifyServerQueue('" ^ line ^ "', "
          ^ string_of_int index ^ ", 'DEC')\">v</button>";
      divs :=
        !divs ^ "</div><button onclick=\"modifyServerQueue('" ^ line ^ "', "
        ^ string_of_int index ^ ", 'REM')\">-</button></div>")
    !queue;
  !divs

let methods = [ `GET; `ADD; `REM; `INC; `DEC; `MOD; `CLS; `ERR ]

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
    | "INC" -> `INC
    | "DEC" -> `DEC
    | "MOD" -> `MOD
    | "CLS" -> `CLS
    | _ -> `ERR
  in
  if meth = `ERR then "ERROR with method"
  else if meth = `CLS then (
    queue := [];
    "Queue cleared")
  else if meth = `MOD then
    let name_elem = List.nth json_list 1 in
    let name = String.sub name_elem 8 (String.length name_elem - 9) in
    let index_elem = List.nth json_list 2 in
    let index = String.sub index_elem 8 (String.length index_elem - 8) in
    let index_int = int_of_string index in
    let value_elem = List.nth json_list 3 in
    let value = String.sub value_elem 9 (String.length value_elem - 10) in
    if index_int >= 0 && index_int < List.length !queue then
      let new_queue = Array.of_list !queue in
      let item = new_queue.(index_int) in
      let cfg =
        List.find_opt (fun cfg -> cfg#name = name) item#configurations
      in
      match cfg with
      | Some cfg ->
          let old_value = cfg#value in
          cfg#set_value value;
          queue := Array.to_list new_queue;
          "Updated " ^ item#name ^ " with new value " ^ cfg#value ^ " from "
          ^ old_value ^ " at index " ^ index
      | None -> "ERROR: Configuration not found"
    else "ERROR: Index out of bounds"
  else if meth <> `GET then
    let name_elem = List.nth json_list 1 in
    let name = String.sub name_elem 8 (String.length name_elem - 9) in
    match meth with
    | `ADD -> (
        match Hashtbl.find_opt Collection.items name with
        | Some factory ->
            let new_instance = factory () in
            (* Create a fresh instance *)
            queue := !queue @ [ new_instance ];
            "Added " ^ name ^ " to the queue. Current queue: "
            ^ String.concat ", " (List.map (fun item -> item#name) !queue)
        | None -> "ERROR: Encoder not found")
    | `REM ->
        let index_elem = List.nth json_list 2 in
        let index = String.sub index_elem 8 (String.length index_elem - 8) in
        let index_int = int_of_string index in
        if index_int < List.length !queue then (
          let removed = List.nth !queue index_int in
          queue :=
            List.mapi
              (fun i item -> if i = index_int then None else Some item)
              !queue
            |> List.filter Option.is_some |> List.map Option.get;
          "Removed " ^ removed#name ^ " from the queue. Current queue: "
          ^ String.concat ", " (List.map (fun item -> item#name) !queue))
        else "ERROR: Index out of bounds"
    | `INC ->
        let index_elem = List.nth json_list 2 in
        let index = String.sub index_elem 8 (String.length index_elem - 8) in
        let index_int = int_of_string index in
        if index_int > 0 && index_int < List.length !queue then (
          let new_queue = Array.of_list !queue in
          let temp = new_queue.(index_int - 1) in
          new_queue.(index_int - 1) <- new_queue.(index_int);
          new_queue.(index_int) <- temp;
          queue := Array.to_list new_queue;
          "Moved up " ^ new_queue.(index_int - 1)#name ^ ". Current queue: "
          ^ String.concat ", " (List.map (fun item -> item#name) !queue))
        else "ERROR: Cannot increase position"
    | `DEC ->
        let index_elem = List.nth json_list 2 in
        let index = String.sub index_elem 8 (String.length index_elem - 8) in
        let index_int = int_of_string index in
        if index_int >= 0 && index_int < List.length !queue - 1 then (
          let new_queue = Array.of_list !queue in
          let temp = new_queue.(index_int + 1) in
          new_queue.(index_int + 1) <- new_queue.(index_int);
          new_queue.(index_int) <- temp;
          queue := Array.to_list new_queue;
          "Moved down " ^ new_queue.(index_int + 1)#name ^ ". Current queue: "
          ^ String.concat ", " (List.map (fun item -> item#name) !queue))
        else "ERROR: Cannot decrease position"
    | _ -> "ERROR with queue manipulation"
  else get_queue_item_names ()

let handle_queue_request (req : string) = parse_json req
