(* bin/main.ml *)

open Lwt.Infix
open Cohttp_lwt_unix

let callback _conn req _body =
  let uri = Request.uri req in
  match Uri.path uri with
  | "/" -> Router.home_page ()
  | "/static/style.css" -> Router.style_sheet ()
  | "/scripts/index.js" -> Router.home_js ()
  | "/encode" ->
      _body |> Cohttp_lwt.Body.to_string >>= fun body_str ->
      Server.respond_string ~status:`OK ~body:(Api.run_encode_queue body_str) ()
  | "/queue" ->
      _body |> Cohttp_lwt.Body.to_string >>= fun body_str ->
      Server.respond_string ~status:`OK
        ~body:(Api.handle_queue_request body_str)
        ()
  | _ -> Router.not_found ()

let server =
  let config = Server.make ~callback () in
  Server.create ~mode:(`TCP (`Port 8080)) config

let () =
  Logs.set_reporter (Logs_fmt.reporter ());
  Logs.set_level (Some Logs.Info);
  let port = 8080 in
  Logs.app (fun f -> f "Starting server on http://localhost:%d" port);
  Lwt_main.run server
