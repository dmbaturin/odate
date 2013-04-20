type weekday =
  [ `Monday
  | `Tuesday
  | `Wednesday
  | `Thursday
  | `Friday
  | `Saturday
  | `Sunday ]

type month =
  [ `January
  | `February
  | `March
  | `April
  | `Mai
  | `June
  | `July
  | `August
  | `September
  | `October
  | `November
  | `December ]

type year = int
type day = int
type tz = int
type human_readable = {
  s : int;
  m : int;
  h : int;
  day : day;
  wday : weekday;
  month : month;
  year: year;
  tz : tz;
}

type parser_
type printer
type format = string

module type Implem = sig
  type t
  val compare : t -> t -> int
  val to_human : ?tz:tz -> t -> human_readable
  val from_human : ?tz:tz -> human_readable -> t
  val now : unit -> t
  val now_milliseconds : unit -> float
  val get_std_timezone : unit -> tz
  val get_dst_timezone : t -> tz
  val add : t -> int -> t
  val from_seconds : int -> t
  val to_seconds : t -> int
end

module Hour : sig
  val is_am : int -> bool
  val convert_24h_to_12h : int -> int
end
module Weekday : sig
  val set_stringifier : (weekday -> string) -> unit
  val set_stringifier_abbr : (weekday -> string) -> unit
  val of_int : int -> weekday
  val to_int : weekday -> int
  val to_string : weekday -> string
  val to_string_short : weekday -> string
end
module Month : sig
  val set_stringifier : (month -> string) -> unit
  val set_stringifier_abbr : (month -> string) -> unit
  val of_int : int -> month
  val to_int : month -> int
  val to_string : month -> string
  val to_string_short : month -> string
  val next : month -> month
  val prev : month -> month
end


module type S = sig
  type t
  type d
  val beginning_of_the_day : t -> t
  val beginning_of_the_month : t -> t
  val beginning_of_the_week : t -> t

  val end_of_the_day : t -> t
  val end_of_the_month : t -> t
  val end_of_the_week : t -> t
  val gmt : tz
  val compare : t -> t -> int
  val empty : human_readable
  val some_if_valid : t -> t option
  val now : unit -> t
  val now_milliseconds : unit -> float
  val get_std_timezone : unit -> tz
  val get_dst_timezone : t -> tz

  val epoch : t
  val make : ?tz:tz -> ?s:int -> ?m:int -> ?h:int -> day:int -> month:month -> year:int -> unit -> t
  (* make date in gmt *)
  val move : t -> d -> t
  val advance_by_minutes : t -> int -> t
  val advance_by_hours : t -> int -> t
  val advance_by_days : t -> int -> t
  val advance_by_months : t -> int -> t
  val advance_by_years : t -> int -> t
  val convert_with_tz : tz -> tz -> t -> t
  val advance_by_weeks : t -> int -> t
  val move_to_weekday : t -> forward:bool -> weekday -> t
  val calendar_advance : t -> Duration.human_readable -> t
  val between : t -> t -> d
  val in_between : t -> t -> t
  val max : t -> t -> t
  val min : t -> t -> t
  val is_after : t -> t -> bool
  val is_before : t -> t -> bool
  val is_epoch : t -> bool
  val get_age : t -> int
  val get_weekday : t -> weekday
  val get_day : t -> int
  val get_month : t -> month
  val get_year : t -> year
  val get_first_week : year -> t
  val get_week_number : t -> int
  val get_min : t -> int
  val get_hour : t -> int
  val get_sec : t -> int

  module Format : sig
    val default : string
    val debug : string
    val birthday : string
    val iso : string
  end
  module Printer : sig
    val combine : printer -> printer -> printer

    val default : printer
    val debug : printer
    val birthday : printer
    val iso : printer
    val to_default : t -> string
    val to_debug : t -> string
    val to_birthday : t -> string
    val to_iso : t -> string
  end
  module Parser : sig
    val combine : parser_ -> parser_ -> parser_
    val sum : parser_ list -> parser_
    val twitter : parser_
    val runkeeper : parser_
    val nike : parser_
    val birthday : parser_
    val from_nike : string -> t
    val from_runkeeper : string -> t
    val from_twitter : string -> t
    val from_birthday : string -> t
    val from_iso : string -> t
  end

  module From : sig
    val seconds : int -> t
    val seconds_float : float -> t
    val generate_parser : string -> parser_ option
    val string : parser_ -> string -> t
    val human : ?tz:tz -> human_readable -> t
  end

  module To : sig
    val seconds : t -> int
    val seconds_float : t -> float
    val generate_printer : string -> printer option
    val string : ?tz:tz -> printer -> t -> string
    val human : ?tz:tz -> t -> human_readable
  end

end

module Make (I : Implem) (D : Duration.S) : S with type t = I.t and type d = D.t
