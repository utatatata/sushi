type pos_type = Top | Bottom | Left | Right

module PosMap = Map.Make(
  struct
    type t = int * int
    let compare (x0,y0) (x1,y1) =
    match Pervasives.compare x0 x1 with
      0 -> Pervasives.compare y0 y1
    | c -> c
  end
)

let default_belt = [ "+--------------------------------------+";
                     "|                                      |";
                     "| +----------------------------------+ |";
                     "| |                                  | |";
                     "| |                                  | |";
                     "| |                                  | |";
                     "| |                                  | |";
                     "| |                                  | |";
                     "| +----------------------------------+ |";
                     "|                                      |";
                     "+--------------------------------------+" ]

let where (r, c) =
  if r = 1 && 1 <= c && c < 38 then Top
  else if r = 9 && 1 < c && c <= 38 then Bottom
  else if c = 1 && 1 < r && r <= 9 then Left
  else if c = 38 && 1 <= r && r < 9 then Right
  else failwith "not on the belt"

let next (r, c) =
  match where (r, c) with
  | Top    -> (r, c + 1)
  | Bottom -> (r, c - 1)
  | Left   -> (r - 1, c)
  | Right  -> (r + 1, c)

let convey m =
  PosMap.fold (fun pos ch m -> m |> PosMap.add (next pos) ch)
              m
              PosMap.empty

let sort_by_row m =
  List.mapi (fun i _ -> PosMap.filter (fun (r, _) _ -> r = i) m)
            default_belt

let build_belt m =
  let l = sort_by_row m in
  default_belt |> List.mapi (fun r s -> s |> String.mapi (fun c ch ->
    let pos = (r, c)
    and m = List.nth l r in
    if PosMap.mem pos m then PosMap.find pos m else ch))

let print_belt belt =
  belt |> List.iter print_endline

let () =
  let rec loop m =
    let m = convey m
    and b = build_belt m in
    Unix.sleepf 0.05;
    Sys.command "clear";
    print_belt b;
    loop m in
  loop (PosMap.empty |> PosMap.add (1, 1) 's'
                     |> PosMap.add (1, 2) 'u'
                     |> PosMap.add (1, 3) 's'
                     |> PosMap.add (1, 4) 'h'
                     |> PosMap.add (1, 5) 'i')

