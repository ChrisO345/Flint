(* bin/main.ml *)

open Lwt.Infix
open Cohttp_lwt_unix

let callback _conn req _body =
  let uri = Request.uri req in
  match Uri.path uri with
  | "/" -> Router.home_page ()
  | "/encode" ->
      _body |> Cohttp_lwt.Body.to_string >>= fun body_str ->
      Server.respond_string ~status:`OK ~body:(Api.run_encode_queue body_str) ()
  | "/queue" ->
      _body |> Cohttp_lwt.Body.to_string >>= fun body_str ->
      Server.respond_string ~status:`OK
        ~body:(Api.handle_queue_request body_str)
        ()
  | _ when String.starts_with ~prefix:"/static" (Uri.path uri) ->
      Router.load_css (Uri.path uri)
  | _ when String.starts_with ~prefix:"/scripts" (Uri.path uri) ->
      Router.load_javascript (Uri.path uri)
  | _ when String.starts_with ~prefix:"/assets" (Uri.path uri) ->
      Router.load_image (Uri.path uri)
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
