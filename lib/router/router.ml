(* lib/router/router.ml *)

open Cohttp_lwt_unix
open Cohttp

let style_sheet () =
  let body = Helpers.read_file "templates/static/style.css" in
  Server.respond_string ~status:`OK
    ~headers:(Header.init_with "Content-Type" "text/css")
    ~body ()

let home_page () =
  let file = Helpers.read_file "templates/index.html" in
  let replaced_file =
    Str.global_replace
      (Str.regexp "{{SEARCH_RESULTS}}")
      (Api.get_filterable_items ())
      file
  in
  Helpers.serve_page ~html_content:replaced_file ~status:`OK

let home_js () =
  let file = Helpers.read_file "templates/scripts/index.js" in
  Server.respond_string ~status:`OK
    ~headers:(Header.init_with "Content-Type" "text/javascript")
    ~body:file ()

let not_found () =
  let file = Helpers.read_file "templates/404.html" in
  Helpers.serve_page ~html_content:file ~status:`Not_found
