module Sushi.Matrix


let mapi f =
  List.mapi
    (fun y s ->
      s |> List.mapi
        (fun x e ->
          f x y e
        )
    )


let set x y e =
  mapi
    (fun mx my me ->
      if mx = x && my = y then
        e
      else
        me
    )

