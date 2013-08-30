open Should

module Make (Duration : Duration.S) (Date : Date.S with type d = Duration.t) = struct

  let format = "%a %b %d %T %z %Y"
  let parseR = match Date.From.generate_parser format with
    | Some p -> p
    | None -> failwith "could not generate parser"
  let printer = match Date.To.generate_printer format with
    | Some p -> p
    | None -> failwith "could not generate printer"

  let test1 =
    let a = Date.now () in
    let d1 = Duration.From.ms 9990 in
    let b = Date.now () in
    let d2 = Date.between a b in
    let d3 = Date.between b a in
    let s1 = Duration.To.string Duration.To.default_printer d2 in
    let s2 = Duration.To.string Duration.To.default_printer d1 in
    let s3 = Duration.To.string Duration.To.default_printer d3 in
    s1 $hould # equal (s3);
    string s2 $hould # contain ("in 9 seconds");
    string s3 $hould # contain ("just now")

  let test2 =
    let d_string = "Wed May 29 20:20:23 +00:00 2013" in
    let d = Date.From.string parseR d_string in
    let s = Date.To.string printer d in
    s $hould # equal(d_string)

  let test3 =
    let s = Date.now () in
    let s''' = Date.To.string printer s in
    print_endline s''';
    let s = Date.beginning_of_the_month s in
    for i = 0 to 40 do
      let s' = Date.advance_by_months s i in
      let s'' = s' in
      let s'' = Date.end_of_the_month s' in
      let s''' = Date.To.string ~tz:(Date.get_dst_timezone s'') printer s'' in
      print_endline s'''
    done
end

module T = Make(Duration)(Date.Unix)
