open Cohttp_lwt_unix

let callback _conn req _body =
  let uri = Request.uri req in
  match Uri.path uri with
  | "/" -> Router.home_page ()
  | "/static/style.css" -> Router.style_sheet ()
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
