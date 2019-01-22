namespace Sushi


module ConveyorBelt =

  type Dimension =
    { Width : int; Height : int }


  type Coord =
    { X : int; Y : int }


  let length { Width = w; Height = h } =
    (w + h - 6) * 2


  let outerEdge { Width = w; Height = _ } =
    "+"
    + String.replicate (w - 2) "-"
    + "+"


  let lane { Width = w; Height = _ } =
    "|"
    + String.replicate (w - 2) " "
    + "|"


  let innerEdge { Width = w; Height = _ } =
    "| +"
    + String.replicate (w - 6) "-"
    + "+ |"


  let inside { Width = w; Height = _ } =
    "| |"
    + String.replicate (w - 6) " "
    + "| |"


  let conveyorBelt ({ Width = _; Height = h } as dim) =
    [outerEdge dim; lane dim; innerEdge dim]
    @ List.replicate (h - 6) (inside dim)
    @ [innerEdge dim; lane dim; outerEdge dim]


  let idxToCoord ({ Width = w; Height = h } as dim) idx =
    let idx = Utilities.modulo (length dim) idx
    match idx with
    | n when n < w - 3 -> { X = idx + 1; Y = 1; }
    | n when n < w + h - 6 -> { X = w - 2; Y = idx - w + 4 }
    | n when n < w * 2 + h - 9 -> { X = w * 2 + h - idx - 8; Y = h - 2 }
    | n -> { X = 1; Y = w * 2 + h * 2 - idx - 11 }

