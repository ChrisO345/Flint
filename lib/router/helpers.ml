(* lib/router/helpers.ml *)

open Cohttp_lwt_unix

let read_file filename =
  try
    let ic = open_in filename in
    let content = really_input_string ic (in_channel_length ic) in
    close_in ic;
    content
  with
  | Sys_error msg ->
      Printf.printf "Error opening file: %s\n" msg;
      ""
  | e ->
      Printf.printf "Unexpected error: %s\n" (Printexc.to_string e);
      ""

let serve_page ~html_content ~status =
  Server.respond_string ~status ~body:html_content ()
